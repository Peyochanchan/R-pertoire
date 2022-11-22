require 'rails_helper'

RSpec.describe SongPolicy do
  let(:user)     { FactoryBot.create(:user) }
  let(:user_one) { FactoryBot.create(:user) }
  let(:song)     { FactoryBot.create(:song, user_id: user.id) }

  context 'for a user trying to access another user\'s public song' do
    let(:valid_attributes) { { title: 'Test Name', lyrics: song.lyrics, public: true, user_id: user.id } }
    let(:new_song)         { Song.new(valid_attributes) }

    subject                { described_class.new(user_one, new_song) }

    it { is_expected.to permit_actions(:show)    }
    it { is_expected.to permit_actions(:new)     }
    it { is_expected.to forbid_actions(:create)  }
    it { is_expected.to forbid_actions(:edit)    }
    it { is_expected.to forbid_actions(:update)  }
    it { is_expected.to forbid_actions(:destroy) }
  end

  context 'for a user trying to access another user\'s private song' do
    let(:valid_attributes) { { title: 'Test Name', public: false, user_id: user.id } }
    let(:new_song)         { Song.new(valid_attributes) }
    let(:user_one)         { FactoryBot.create(:user) }

    subject { described_class.new(user_one, new_song) }

    it { is_expected.to forbid_actions(:show)    }
    it { is_expected.to permit_actions(:new)     }
    it { is_expected.to forbid_actions(:create)  }
    it { is_expected.to forbid_actions(:edit)    }
    it { is_expected.to forbid_actions(:update)  }
    it { is_expected.to forbid_actions(%i[show destroy]) }
  end

  context 'For An User accessing his data' do
    subject { described_class.new(user, song) }

    it { is_expected.to permit_actions(:new)     }
    it { is_expected.to forbid_actions(:create)  }
    it { is_expected.to permit_actions(:edit)    }
    it { is_expected.to permit_actions(:update)  }
    it { is_expected.to permit_actions(%i[show destroy]) }
  end

  context 'For An Administrator trying to access other user\'s song' do
    let(:user_admin) { FactoryBot.build(:user, :admin) }
    subject { described_class.new(user_admin, song) }

    it { is_expected.to permit_actions(:create)  }
    it { is_expected.to permit_actions(:new)     }
    it { is_expected.to permit_actions(:update)  }
    it { is_expected.to permit_actions(:edit)    }
    it { is_expected.to permit_actions(%i[show destroy]) }
  end
end
