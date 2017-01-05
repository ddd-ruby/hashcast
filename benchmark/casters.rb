class ContactCaster
  include HashCast::Caster
  attributes do
    hash :contact do
      string   :name
      integer  :age, optional: true
      float    :weight
      date     :birthday
      datetime :last_logged_in
      time     :last_visited_at
      hash :company do
        string :name
      end
      array :emails, each: :string
      array :social_accounts, each: :hash do
        string :name
        symbol :type
      end
    end
  end
end


#########

class SettingsCaster
  include HashCast::Caster

  attributes do
    string :account
  end
end

class EmailCaster
  include HashCast::Caster

  attributes do
    string :address
  end
end

class CompanyCaster
  include HashCast::Caster

  attributes do
    string :name
    hash   :settings, caster: SettingsCaster
    array  :emails,  caster: EmailCaster
  end
end
