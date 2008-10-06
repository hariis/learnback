class Opinion < ActiveRecord::Base
  has_many :comments
  belongs_to :user
  
  validates_presence_of :description , :message => "Description can't be blank"
  serialize :voters
  
  def record_voter(user)
         if voters
           allvoters = voters
         else
           allvoters = []
         end
         if allvoters.include?(user) == false
             allvoters << user 
             update_attribute(:voters , allvoters)
         end
  end
  def is_eligible_to_vote(user)         
         if voters
           allvoters = voters
         else
           return true
         end
         
         return false if allvoters.include?(user) 
         return true
  end
  def self.searchw(filter, page)       
        paginate :per_page =>5, :page => page,
           :conditions => ['dept = ? and kind =?', filter, "W" ], 
           :order => "created_at desc"
   end
   def self.searchn(filter, page)
        paginate :per_page =>5, :page => page,
           :conditions => ['dept = ? and kind =?', filter, "N" ], 
           :order => "created_at desc"
   end
   def self.searchw_by_user(page,user)       
        paginate :per_page =>5, :page => page,
           :conditions => ['kind =? and user_id = ?', "W", user.id ], 
           :order => "created_at desc"
   end
   def self.searchn_by_user(page,user)
        paginate :per_page =>5, :page => page,
           :conditions => ['kind =? and user_id = ?', "N", user.id ], 
           :order => "created_at desc"
   end
   def self.search_all(filter,kind)
     Opinion.find(:all, :conditions => ['dept = ? and kind =?', filter, kind ],
                                                     :order => "created_at desc" )
    
   end
   def self.search_all_by_user(kind,user)
     Opinion.find(:all, :conditions => ['kind =? and user_id = ?',  kind,user.id ],
                                                     :order => "created_at desc" )
    
   end
   def self.search(keyword)
     criteria = '%' + keyword + '%'
     Opinion.find(:all, :conditions => ["description like ?",criteria ])
   end
  #DEPTS = {"P" => "PIV", "I" => "IIV", "PD" => "Prog. Dev"}
  DEPTS = { "PIV" => "1", "IIV" => "2", "SIV" => "3", "Prog. Dev" => "4", "UTE" => "5", "LearnBack" => "6", "My Opinions" => "7"}
end
