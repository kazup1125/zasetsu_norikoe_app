# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  # FactoryBotでUserをオブジェクト化
  let(:user) { build(:user) }

  describe 'モデルバリデーション' do
    it 'メールアドレス、パスワード、名前、性別、就業形態、挫折カウントが入力されている場合、有効である' do
      expect(user).to be_valid
    end

    it 'メールアドレスが無い場合、無効である' do
      user.email = ''
      user.valid?
      expect(user.errors[:email]).to include(I18n.t('errors.messages.blank'))
    end

    it 'すでに登録してあるメールアドレスを登録しようとした場合、無効である' do
      user.email = 'test@example.com'
      user.save
      other_user = build(:user, email: 'test@example.com')
      other_user.valid?
      expect(other_user.errors[:email]).to include(I18n.t('errors.messages.taken'))
    end

    it '@がないメールアドレスの場合、無効である' do
      user.email = 'test.example.com'
      user.valid?
      expect(user.errors[:email]).to include(I18n.t('errors.messages.invalid'))
    end

    it '@が二つあるメールアドレスの場合、無効である' do
      user.email = 'test@@example.com'
      user.valid?
      expect(user.errors[:email]).to include(I18n.t('errors.messages.invalid'))
    end

    it 'パスワードが無い場合、無効である' do
      user.password = ''
      user.valid?
      expect(user.errors[:password]).to include(I18n.t('errors.messages.blank'))
    end

    it 'パスワードが6文字の場合、無効である' do
      user.password = '123456'
      user.valid?
      expect(user.errors[:password]).to include(I18n.t('errors.messages.too_short', count: 8))
    end

    it '名前が無い場合、無効である' do
      user.name = ''
      user.valid?
      expect(user.errors[:name]).to include(I18n.t('errors.messages.blank'))
    end

    it '性別が無い場合、無効である' do
      user.gender = ''
      user.valid?
      expect(user.errors[:gender]).to include(I18n.t('errors.messages.blank'))
    end

    it '就業形態が無い場合、無効である' do
      user.employment_type = ''
      user.valid?
      expect(user.errors[:employment_type]).to include(I18n.t('errors.messages.blank'))
    end

    it '挫折カウントが無い場合、無効である' do
      user.zasetsu_count = ''
      user.valid?
      expect(user.errors[:zasetsu_count]).to include(I18n.t('errors.messages.blank'))
    end

    context 'URL系のカラム' do
      it 'FacebookのURLに無効なURLが入力されている場合、無効である' do
        user.facebook_url = 'FacebookのURLです'
        user.valid?
        expect(user.errors[:facebook_url]).to include(I18n.t('errors.messages.invalid'))
      end

      it 'InstagramのURLに無効なURLが入力されている場合、無効である' do
        user.insta_url = 'InstagramのURLです'
        user.valid?
        expect(user.errors[:insta_url]).to include(I18n.t('errors.messages.invalid'))
      end

      it 'TwitterのURLに無効なURLが入力されている場合、無効である' do
        user.twitter_url = 'TwitterのURLです'
        user.valid?
        expect(user.errors[:twitter_url]).to include(I18n.t('errors.messages.invalid'))
      end

      it 'GitHubのURLに無効なURLが入力されている場合、無効である' do
        user.github_url = 'GitHubのURLです'
        user.valid?
        expect(user.errors[:github_url]).to include(I18n.t('errors.messages.invalid'))
      end

      it 'ポートフォリオのURLに無効なURLが入力されている場合、無効である' do
        user.port_url = 'ポートフォリオのURLです'
        user.valid?
        expect(user.errors[:port_url]).to include(I18n.t('errors.messages.invalid'))
      end
    end
  end

  describe 'アソシーエション' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context 'SkillCategoryモデルとの関係' do
      let(:target) { :skill_categories }

      it 'has_manyである' do
        expect(association.macro).to eq :has_many
      end
    end

    context 'UserAndSkillCategoryRelationshipモデルとの関係' do
      let(:target) { :user_and_skill_category_relationships }

      it 'has_manyである' do
        expect(association.macro).to eq :has_many
      end
    end

    context 'SkillSetモデルとの関係' do
      let(:target) { :skill_sets }

      it 'has_manyである' do
        expect(association.macro).to eq :has_many
      end
    end

    context 'UserAndSkillSetRelationshipモデルとの関係' do
      let(:target) { :user_and_skill_set_relationships }

      it 'has_manyである' do
        expect(association.macro).to eq :has_many
      end
    end
  end

  describe 'スキル属性とスキルセットと紐付いているUser' do
    let!(:user) { create(:user, :with_skill_sets) }

    context 'Userが削除された時' do
      it '紐付くUserAndSkillCategoryRelationshipも削除される' do
        expect { user.destroy }.to change(UserAndSkillCategoryRelationship, :count).by(-1)
      end

      it '紐付くUserAndSkillSetRelationshipも削除される' do
        expect { user.destroy }.to change(UserAndSkillSetRelationship, :count).by(-1)
      end
    end
  end
end
