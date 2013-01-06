class Movie < ActiveRecord::Base
  after_initialize :set_default_param
  primary_key= :key
  default_scope where('del_flg=0')

  def self.get_identifiers(site_name)
    self.where(site: site_name).select('identifier').map { |v| v.identifier }
  end

  def set_default_param
    self.del_flg         ||= 0
    self.use_flg         ||= 0
    self.mylist_counter  ||= 0
    self.comment_counter ||= 0
    self.view_counter    ||= 0
  end

end
