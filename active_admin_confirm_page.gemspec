$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_admin_confirm_page/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_admin_confirm_page"
  s.version     = ActiveAdminConfirmPage::VERSION
  s.authors       = ["Hiroaki Nakamura"]
  s.email         = ["func.nakamura@1pac.jp"]
  s.description   = %q{Inserts a confirm page before committing to create or edit resources managed by ActiveAdmin.}
  s.summary       = %q{Inserts a confirm page to ActiveAdmin.}
  s.homepage      = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc", "README.ja.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  # s.add_dependency "jquery-rails"
  s.add_dependency "activeadmin"

  s.add_development_dependency "sqlite3"
end
