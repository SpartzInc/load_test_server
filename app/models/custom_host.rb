

=begin
how i had to edit my local /etc/sudoers:
Defaults    env_keep += "rvm_bin_path GEM_HOME IRBRC MY_RUBY_HOME rvm_path rvm_prefix rvm_version GEM_PATH rvmsudo_secure_path RUBY_VERSION rvm_ruby_string rvm_delete_flag RUBYLIB _ORIGINAL_GEM_PATH RUBYOPT BUNDLE_GEMFILE rvm_user_install_flag rvm_loaded_flag rvm_stored_umask"

#last line:
eriks ALL = NOPASSWD: /Users/eriks/.rvm/gems/ruby-2.1.4/bin/ghost


.profile (for sh)- add line
export rvmsudo_secure_path=0

https://rvm.io/integration/sudo


=end


require 'resolv'

class CustomHost < ActiveRecord::Base

  #get absolute ghost path for any env
  GHOST_PATH = `which ghost`.chomp
  GHOST_LIST_REGEXP = /Listing\s(\d+)\shost\(s\):\s+([\w\W]+)/

  validates_presence_of :hostname, :description

  validates :ip_address, presence: true, format: { with: Resolv::IPv4::Regex }

  before_save :change_active
  after_save :ghost_list_valid?


  def activate!
    unless active
      add_ghost ? self.update(active: true) : false
    end
  end

  def deactivate!
    if active
      delete_ghost ? self.update(active: false) : false
    end
  end




  def ghost_list_valid?
    ghost_list = self.class.parse_ghost_list
    host_list = self.class.active_hosts.map { |host| [host.hostname, host.ip_address] }

    if ghost_list.sort != host_list.sort
      self.errors.add(:db_ghost_sync_error, "database and ghosts are out of sync")
      warn "Warning: active CustomHosts don't match active ghosts. Maybe try to re-sync the entire ghost list? If you were trying to save an existing custom host, it will be rolled back.", "\t" + {active_hosts: host_list, active_ghosts: ghost_list}.to_s
      raise ActiveRecord::RecordInvalid.new(self)
    end
    true
  end

  def self.parse_ghost_list
    list = list_ghosts
    if match_data = GHOST_LIST_REGEXP.match(list)
      lines = match_data[2].split("\n").map{ |str| str.gsub(/\s+/,"") }
      return ghost_array = lines.map { |line| line.split("->") }
    else
      []
    end
  end

  def self.bust_ghosts
    system("rvmsudo #{GHOST_PATH} bust")
  end


  def self.list_ghosts
    `#{GHOST_PATH} list`
  end

  def self.active_hosts
    self.all.where(active: true)
  end

  def change_active
    if self.active_changed?
      active ? add_ghost : delete_ghost
    end
  end

  def add_ghost
    system("rvmsudo #{GHOST_PATH} add #{hostname} #{ip_address}")
  end

  def delete_ghost
    if system("rvmsudo #{GHOST_PATH} delete #{hostname}")
      # binding.pry # to account for multiple identical hostnames
      if actives = self.class.active_hosts.reject { |host| host.id == self.id }.select { |host| host.hostname == self.hostname}
        actives.each(&:add_ghost)
      end
      return true
    end
  end


end
