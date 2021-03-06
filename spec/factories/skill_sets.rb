# frozen_string_literal: true

FactoryBot.define do
  # ランダム（プログラミング言語、アプリ名、OS名）
  factory :skill_set do
    sequence(:name) do
      [
        Faker::Computer.os,
        Faker::ProgrammingLanguage.name,
        Faker::App.name
      ].sample
    end

    # プログラミング言語
    trait :pg_lang do
      sequence(:name) { Faker::ProgrammingLanguage.name }
    end

    # アプリの名前
    trait :app_name do
      sequence(:name) { Faker::App.name }
    end

    # OSの名前
    trait :os do
      sequence(:name) { Faker::Computer.os }
    end

    # Userも一緒に作成する
    trait :with_users do
      after(:create) do |skill_set|
        create(:user_and_skill_set_relationship, skill_set: skill_set)
      end
    end

    association(:skill_category)
  end
end
