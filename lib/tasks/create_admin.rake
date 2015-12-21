desc 'create_admin'
  task :create_admin, [:email] => :environment do |t, args|
    User.where(email: args.email).each do |user|
      user.update_columns(role: :admin)
    end
  end
