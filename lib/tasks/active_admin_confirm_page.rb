def index_of_resource_def_line(lines)
  lines.index do |line|
    resource = /^ActiveAdmin\.register\s+(\S+)\s+do/.match(line).to_a[1]
    resource && resource != 'AdminUser'
  end
end

def has_confirm_page?(lines)
  lines.any? { |line| /^\s*include\s+ActiveAdminConfirmPage/.match line }
end

namespace :active_admin_confirm_page do
  desc 'Check a confirm page is inserted for resources'
  task :check_resources do
    not_ready_files = []
    Dir.glob('app/admin/*.rb') do |file|
      lines = IO.readlines file
      if index_of_resource_def_line(lines) != nil &&
          !has_confirm_page?(lines)
        not_ready_files << file
      end
    end

    unless not_ready_files.empty?
      puts 'These files does not have a confirm page:'
      not_ready_files.each {|file| puts file }
    end
  end

  desc 'Modify resources to have a confirm page'
  task :modify_resources do
    Dir.glob('app/admin/*.rb') do |file|
      lines = IO.readlines file
      index = index_of_resource_def_line(lines)
      if index != nil && !has_confirm_page?(lines)
        lines.insert(index + 1, "  include ActiveAdminConfirmPage\n")
        IO.write(file, lines.join(""))
        puts "modified #{file}"
      end
    end
  end
end
