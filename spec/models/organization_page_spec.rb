require 'spec_helper'

describe OrganizationPage, :model do
  it_behaves_like "is translatable" do
    let(:model) { create :organization_page }
  end

  it_behaves_like "a versioned model"
end
