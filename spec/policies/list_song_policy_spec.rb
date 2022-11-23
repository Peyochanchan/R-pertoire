require 'rails_helper'
# require 'support/controller_macros'
RSpec::Mocks.configuration.allow_message_expectations_on_nil = true

RSpec.describe ListSongPolicy do
  let(:user)     { FactoryBot.create(:user) }
  let(:song)     { FactoryBot.create(:song, public: true, user_id: user.id) }
  let(:list)     { FactoryBot.create(:list, user_id: user.id) }
  let(:user_one) { FactoryBot.create(:user) }
  let(:list_song_one) { FactoryBot.create(:list_song, :private, tonality: 'A', song_id: song.id, list_id: list.id) }

  let(:public_attributes) { { title: 'Test Name', lyrics: song.lyrics, public: true, user_id: user.id } }
  let(:private_attributes) { { title: 'Test Name', lyrics: song.lyrics, public: false, user_id: user.id } }
  let(:new_song) { Song.new }
  let(:list_song) { FactoryBot.create(:list_song, :public) }

  context 'for a user trying to access another user\'s public list song' do
    subject { described_class.new(user_one, list_song) }

    it { is_expected.to forbid_actions(:create)  }
    it { is_expected.to forbid_actions(:new)     }
    it { is_expected.to forbid_actions(:update)  }
    it { is_expected.to forbid_actions(:edit)    }
    it { is_expected.to forbid_actions(:destroy) }
  end

  context 'for a user trying to access another user\'s private list song' do
    subject { described_class.new(user_one, list_song_one) }

    it { is_expected.to forbid_actions(:create)  }
    it { is_expected.to forbid_actions(:new)     }
    it { is_expected.to forbid_actions(:update)  }
    it { is_expected.to forbid_actions(:edit)    }
    it { is_expected.to forbid_actions(%i[show destroy]) }
  end

  context 'For A User getting #actions on his data' do
    subject { described_class.new(user, list_song_one) }

    it { is_expected.to permit_actions(:new)     }
    it { is_expected.to permit_actions(:create)  }
    it { is_expected.to permit_actions(:update)  }
    it { is_expected.to permit_actions(:edit)    }
    it { is_expected.to permit_actions(:destroy) }
  end

  context 'For An Administrator trying to access other user\'s list song' do
    let(:user_admin) { FactoryBot.create(:user, admin: true) }
    let(:song_admin) { FactoryBot.create(:song, user_id: user_admin.id) }
    let(:list_songs) { FactoryBot.create_list(:list_song, 5) }

    subject { described_class.new(user_admin, list_song) }

    it { is_expected.to permit_actions(:create)  }
    it { is_expected.to permit_actions(:new)     }
    it { is_expected.to permit_actions(:update)  }
    it { is_expected.to permit_actions(:edit)    }

    it 'allows An Administrator trying to destroy other user\'s list song' do
      expect(described_class.new(user_admin, list_songs)).to permit_actions(:destroy_multiple)
    end
  end
end
