testcase Backload do

  context "#require" do

    test "the callbacks are made, before and after" do
      seen = calls{ require 'example_require' }
      seen.map{ |c| c[0] }.assert == [:backloading, :required, :backloaded]
      seen.map{ |c| c[1] }.uniq.assert == ['example_require']
      opts = seen.last[2]
      opts[:require].assert == true
      opts[:load].assert == false
      opts[:relative].assert.nil?
      opts[:depth].assert == 0
      $example_require.assert == true
    end

    test "a feature loaded before gets the before callback only" do
      require 'example_require'
      seen = calls{ (require 'example_require').assert == false }
      seen.map{ |c| c[0] }.assert == [:backloading]
    end

    test "a require that raises gets the before callback only, and the depth is put back" do
      seen = calls do
        LoadError.assert.raised?{ require 'example_no_such_file' }
        RuntimeError.assert.raised?{ require 'example_raise' }
      end
      seen.map{ |c| c[0] }.assert == [:backloading, :backloading]
      seen.map{ |c| c[2][:depth] }.assert == [0, 0]
    end

    test "Kernel.require is hooked too, and is still public" do
      $LOADED_FEATURES.delete_if{ |f| f.end_with?('example_require.rb') }
      seen = calls{ Kernel.require 'example_require' }
      seen.map{ |c| c[0] }.assert == [:backloading, :required, :backloaded]
    end

    test "#require stays private on objects" do
      Object.new.respond_to?(:require).assert == false
      Object.new.respond_to?(:load).assert == false
      Object.new.respond_to?(:require_relative).assert == false
      Kernel.respond_to?(:require).assert == true
      Kernel.respond_to?(:load).assert == true
    end

    test "a Pathname will do" do
      require 'pathname'
      $LOADED_FEATURES.delete_if{ |f| f.end_with?('example_require.rb') }
      (require Pathname.new(File.join(FIXTURES, 'example_require.rb'))).assert == true
    end

  end

  context "#load" do

    test "the callbacks are made, every time" do
      count = (defined?($example_load) ? $example_load.to_i : 0)
      seen = calls{ load 'example_load.rb'; load 'example_load.rb' }
      seen.map{ |c| c[0] }.assert == [:backloading, :loaded, :backloaded] * 2
      opts = seen.last[2]
      opts[:load].assert == true
      opts[:require].assert == false
      opts[:wrap].assert == false
      $example_load.assert == count + 2
    end

    test "the wrap argument is passed on and reported" do
      seen = calls{ load 'example_load.rb', true }
      seen[1].assert == [:loaded, 'example_load.rb', true]
      seen.last[2][:wrap].assert == true
    end

    test "Kernel.load is hooked too" do
      seen = calls{ Kernel.load 'example_load.rb' }
      seen.map{ |c| c[0] }.assert == [:backloading, :loaded, :backloaded]
    end

  end

  context "#require_relative" do

    test "the callbacks are made, with the directory it is relative to" do
      seen = calls{ require_relative 'fixtures/example_relative' }
      seen.map{ |c| c[0] }.assert == [:backloading, :required_relative, :backloaded]
      seen.map{ |c| c[1] }.uniq.assert == ['fixtures/example_relative']
      seen[1][2].assert == __dir__
      opts = seen.last[2]
      opts[:require].assert == true
      opts[:relative].assert == __dir__
      $example_relative.assert == true
    end

    test "it is reported once, not as a #require as well" do
      seen = calls{ require_relative 'fixtures/example_relative' }
      seen.map{ |c| c[0] }.refute.include?(:required)
    end

    test "a missing file is a LoadError" do
      LoadError.assert.raised?{ require_relative 'fixtures/example_no_such_file' }
    end

    test "a callback that takes only the feature still works" do
      out = IO.popen([RbConfig.ruby, '-Ilib', '-e', <<-RUBY, :err=>[:child, :out]]){ |io| io.read }
        require 'backload'
        def Kernel.required_relative(feature); puts "got \#{feature}"; end
        File.write('#{FIXTURES}/tmp_caller.rb', "require_relative 'example_relative'")
        begin
          load '#{FIXTURES}/tmp_caller.rb'
        ensure
          File.delete('#{FIXTURES}/tmp_caller.rb')
        end
      RUBY
      out.assert.end_with?("got example_relative\n")
    end

  end

  context "nesting" do

    test "the depth says how many loads a load is inside of" do
      seen = calls{ require 'nest/outer' }
      before = seen.select{ |c| c[0] == :backloading }.map{ |c| [c[1], c[2][:depth]] }
      before.assert == [['nest/outer', 0], ['nest/inner', 1], ['sibling', 1], ['nest/deep', 2]]
      after = seen.select{ |c| c[0] == :backloaded }.map{ |c| c[1] }
      after.assert == ['nest/inner', 'nest/deep', 'sibling', 'nest/outer']
      $nest_inner.assert == true
      $nest_sibling.assert == true
    end

  end

  context "autoload" do

    test "an autoload is seen as the require it makes" do
      Object.autoload(:AutoThing, 'auto_thing')
      seen = calls{ AutoThing }
      seen.map{ |c| c[0] }.assert == [:backloading, :required, :backloaded]
      seen.last[1].assert == 'auto_thing'
    end

  end

  context "without callbacks defined" do

    test "loading works as usual, and warns of nothing" do
      out = IO.popen([RbConfig.ruby, '-w', '-Ilib', "-I#{FIXTURES}", '-e', <<-RUBY, :err=>[:child, :out]]){ |io| io.read }
        require 'backload'
        require 'backload/require_relative'
        require 'nest/outer'
        load 'example_load.rb'
        puts [$nest_inner, $nest_sibling, $example_load].inspect
      RUBY
      out.lines.grep(/warning/).assert == []
      out.assert.end_with?("[true, true, 1]\n")
    end

  end

  context "backload/trace" do

    test "it prints loads as they start, indented by depth" do
      out = IO.popen([RbConfig.ruby, '-Ilib', "-I#{FIXTURES}", '-rbackload/trace', '-e', "require 'nest/outer'; load 'example_load.rb'", :err=>[:child, :out]]){ |io| io.read }
      out.assert.end_with?("require nest/outer\n  require nest/inner\n  require_relative sibling\n    require nest/deep\nload example_load.rb\n")
    end

  end

end
