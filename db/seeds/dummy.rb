# frozen_string_literal: true

require 'csv'

module Dummy
  class << self
    def import_dummy_users_csv
      print 'Import Users from CSV'

      csv_file_path = 'db/seeds/dummy_users_data.csv'

      CSV.foreach(csv_file_path, headers: true) do |row|
        init_user = User.find_or_initialize_by(user_info_from(row)) do |user|
          user.password = 'password'
        end
        add_skills_to(init_user, row)
        init_user.save
        print '.'
      end

      puts 'done!'
    end

    def user_info_from(resource)
      {
        email: resource['email'],
        name: resource['name'],
        gender: convert_gender(resource['gender']),
        age: resource['age'],
        employment_type: convert_employment_type(resource['employment_type']),
        prefecture: resource['prefecture'],
        available_work_time: resource['available_work_time'],
        qualification: resource['qualification'],
        hobby: resource['hobby'],
        special_skill: resource['special_skill'],
        want_talk: resource['want_talk'],
        not_want_talk: resource['not_want_talk'],
        free_area: resource['free_area'],
        facebook_url: resource['facebook_url'],
        insta_url: resource['insta_url'],
        twitter_url: resource['twitter_url'],
        github_url: resource['github_url'],
        port_url: resource['port_url']
      }
    end

    def convert_gender(resource)
      gender_lists = {
        '未回答' => :not_known,
        '男性' => :male,
        '女性' => :female,
        'その他' => :other
      }
      gender_lists[resource]
    end

    def convert_employment_type(resource)
      employment_type_lists = {
        '正社員' => :full_time,
        '正社員(異業種)' => :diff_full_time,
        '副業' => :side_biz,
        'フリーランス' => :freelance,
        'インターン' => :internship,
        '求職中' => :job_seeker
      }
      employment_type_lists[resource]
    end

    def add_skills_to(user, resource)
      SkillCategory.find_each do |skill_category|
        unless resource[skill_category.name].nil?
          user.skill_categories << skill_category
          resource[skill_category.name].split(', ').each do |skill_name|
            skill_set = SkillSet.find_by(name: skill_name, skill_category: skill_category)
            user.skill_sets << skill_set
          end
        end
      end
    end
  end
end

Dummy.import_dummy_users_csv
