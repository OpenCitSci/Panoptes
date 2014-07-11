FactoryGirl.define do
  factory :user_group do
    sequence(:display_name) {|n| "User Group #{n}"}
    activated_state :active
    after(:build) do |user_group|
      unless user_group.uri_name
        user_group.uri_name = build(:uri_name, name: user_group.display_name, resource: user_group)
      end
    end

    factory :user_group_with_users do
      after(:create) do |ug|
        create_list(:membership, 2, user_group: ug)
      end
    end

    factory :user_group_with_projects do
      after(:create) do |ug|
        create_list(:project, 2, owner: ug)
      end
    end

    factory :user_group_with_collections do
      after(:Create) do |ug|
        create_list(:collections, 2, owner: ug)
      end
    end
  end
end
