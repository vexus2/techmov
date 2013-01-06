class Tag < ActiveRecord::Base
  attr_accessible :del_flg, :tag

  default_scope where('del_flg=0')
end
