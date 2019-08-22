require 'rails_helper'

RSpec.feature "ProductorsRecapMaps", type: :feature do
  describe "address coordinates auto-search" do
    context "when a new productor is created" do
      let(:productor) { build :productor }

      context "and an address is given" do
        before { productor.address = build :address }

        it "fetches coordinates if no coordinates are given" do
          
        end
        
        it "does not fetch coordinates if coordinates are given" do
          expect(productor).not_to receive(:fetch_coordinates)
        end
      end

      context "and no address is given" do
        it "does not fetch coordinates" do
          
        end
      end
    end

    context "when a productor is updated" do
      context "and its address is also updated" do
        it "fetches new coordinaes if no new coordinates are given" do
          
        end
        
        it "does not fetch new coordinates if new coordinates are given" do
          
        end
      end

      context "and its address is not updated" do
        it "does not fetch coordinates" do
          
        end
      end
    end
    
  end
  
end
