namespace :messaging do
  task :run, [:class_name] => [:environment] do |_t, args|
    consumer_class = Kernel.const_get(args.class_name)

    Messaging.start_runner(consumer_class)
  end
end
