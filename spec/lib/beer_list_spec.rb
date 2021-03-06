require 'spec_helper'

describe BeerList do
  let(:establishment){ BeerList::Establishments::ThreeSquares.new }

  describe '.establishments' do

    after(:each) do
      BeerList.clear_establishments!
    end

    it 'returns an array' do
      BeerList.establishments.should be_an_instance_of Array
    end
  end

  describe '.add_establishment' do
    let(:muddy_waters){ BeerList::Establishments::MuddyWaters.new }

    after(:each) do
      BeerList.clear_establishments!
    end

    it 'appends to establishments' do
      BeerList.add_establishment establishment
      BeerList.establishments.should include establishment
    end

    it 'accepts multiple establishments' do
      BeerList.add_establishment establishment, muddy_waters
      BeerList.establishments.size.should == 2
    end

    it 'rejects invalid input' do
      BeerList.add_establishment muddy_waters, Object.new
      BeerList.establishments.size.should == 1
    end

    it 'can be called multiple times' do
      BeerList.add_establishment muddy_waters
      BeerList.add_establishment establishment
      BeerList.establishments.size.should == 2
    end
  end

  describe '.clear_establishments!' do

    shared_examples_for 'clear_establishments!' do
      it 'should empty the collection' do
        BeerList.clear_establishments!
        BeerList.establishments.should be_empty
      end
    end

    context 'when establishments are registered' do
      before do
        BeerList.add_establishment establishment
      end

      it_behaves_like 'clear_establishments!'
    end

    context 'when no establishments are registered' do
      it_behaves_like 'clear_establishments!'
    end
  end

  describe '.lists' do
    context 'when no establishments are registered' do
      it 'should raise an error' do
        BeerList.clear_establishments!
        expect { BeerList.lists }.to raise_error(BeerList::NoEstablishmentsError)
      end
    end

    context 'when establishments are registered' do
      before(:all) do
        BeerList.add_establishments establishment
      end

      after(:all) do
        BeerList.clear_establishments!
      end

      before do
        establishment.stub(:get_list){ ['Darkness', 'Pliney the Elder'] }
      end

      it 'returns an array of lists' do
        BeerList.lists.all?{ |l| l.is_a? BeerList::List }.should be_true
      end

      it 'contains lists for the registered establishments' do
        BeerList.lists.first.establishment.should == 'ThreeSquares'
      end

      describe '.lists_as_hash' do
        it 'returns a hash' do
          BeerList.lists_as_hash.should be_an_instance_of Hash
        end
      end

      describe '.lists_as_json' do
        it 'returns JSON' do
          expect { JSON.parse(BeerList.lists_as_json) }.to_not raise_error
        end
      end
    end
  end

end
