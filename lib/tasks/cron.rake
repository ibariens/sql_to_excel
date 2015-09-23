namespace :cron do
  desc "Frequently run cron task"
  task :often => :environment do
    Dir.chdir(Dir.pwd) do
      `git pull`
    end

    Dir.chdir(Dir.pwd + "/queries") do
      `git pull`
    end

    Dir.chdir(Dir.pwd) do
      `git add queries/`
      `git commit -m 'automatic update of queries'`
      `git push`
    end

    SqlFile.add_files_to_db
  end
end
