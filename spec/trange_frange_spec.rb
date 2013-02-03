# -*- coding: utf-8 -*-

require 'spec_helper'
require 'trange_frange'

describe TrangeFrange do
  it 'should have a VERSION constant' do
    subject.const_get('VERSION').should_not be_empty
  end

  describe TrangeFrange::Member do
    let(:base) { TrangeFrange::Member.new '123' }

    describe '#one' do
      context 'when 123' do
        specify { base.one.should eq('3') }
      end
    end

    describe '#ten' do
      context 'when 123' do
        specify { base.ten.should eq('2') }
      end
    end

    describe '#hundred' do
      context 'when 123' do
        specify { base.hundred.should eq('1') }
      end
    end
  end

  describe TrangeFrange::OrderCondition do
    let(:order_condition) { OrderCondition.new }
    before do
      order_condition.add { nil }
      order_condition.add { 'content' }
      order_condition.add { nil }
    end

    describe '#add' do  
      specify { order_condition.send(:conditions).class.should eq(Array) }
      specify do
        order_condition.send(:conditions).map do |condition| 
          condition.instance_of?(Proc)
        end.uniq.should eq([true])
      end
      specify do 
        order_condition.send(:conditions).map(&:call).should match_array([nil, 'content', nil])
      end
    end

    describe '#match!' do
      specify { order_condition.match!.should eq('content') }
    end
  end

  describe TrangeFrange::Base do
    describe '#teen?' do
      context 'when 123' do
        let(:base) { TrangeFrange::Base.new '123' }
        specify { base.teen?.should be_false }
      end

      context 'when 113' do
        let(:base) { TrangeFrange::Base.new '113' }
        specify { base.teen?.should be_true }
      end
    end

    describe '#gender?' do
      context 'when not gender' do
        let(:non_gender) { Array 3..9 }
        let(:bases) do 
          non_gender.map { |non_gender| TrangeFrange::Base.new "12#{non_gender}" }
        end
        specify do 
          bases.each { |base| base.gender?.should be_false }
        end
      end

      context 'when gender' do
        let(:gender) { Array 1..2 }
        let(:bases) do 
          gender.map { |gender| TrangeFrange::Base.new "12#{gender}" }
        end
        specify do
          bases.each { |base| base.gender?.should be_true }
        end
      end
    end
  end

  describe TrangeFrange::Suffix do
    describe '#gender?' do
      context 'when gender' do
        let(:gender) { Array(2..4) }
        let(:suffixes) do 
          gender.map { |gender| TrangeFrange::Suffix.new "12#{gender}" }
        end
        specify do 
          suffixes.each { |suffix| suffix.gender?.should be_true }
        end
      end

      context 'when not gender' do
        let(:non_gender) { Array(5..9) << 1 }
        let(:suffixes) do 
          non_gender.map { |non_gender| TrangeFrange::Suffix.new "12#{non_gender}" }
        end
        specify do 
          suffixes.each { |suffix| suffix.gender?.should be_false }
        end
      end
    end

    describe '#one?' do
      context 'when one' do
        let(:suffix) { TrangeFrange::Suffix.new '121' }
        specify { suffix.one?.should be_true }
      end

      context 'when not one' do
        let(:suffixes) { TrangeFrange::Suffix.new '123' }
        specify { suffixes.one?.should be_false }
      end
    end
  end

  describe TrangeFrange::One do
    describe '#gender' do
      context 'when magnitude is odd' do
        let(:one) { TrangeFrange::One.new '123', 0 }
        specify { one.send(:gender).should eq(:m) }
      end

      context 'when magnitude is even' do
        let(:one) { TrangeFrange::One.new '123', 1 }
        specify { one.send(:gender).should eq(:f) }
      end
    end

    describe '#word' do
      context 'when simple' do
        specify { TrangeFrange::One.new('120', 0).word.should eq(String.new) }
        specify { TrangeFrange::One.new('123', 1).word.should eq('tri') }
        specify { TrangeFrange::One.new('124', 2).word.should eq('četiri') }
        specify { TrangeFrange::One.new('125', 3).word.should eq('pet') }
        specify { TrangeFrange::One.new('126', 4).word.should eq('šest') }
        specify { TrangeFrange::One.new('127', 5).word.should eq('sedam') }
        specify { TrangeFrange::One.new('128', 6).word.should eq('osam') }
        specify { TrangeFrange::One.new('129', 7).word.should eq('devet') }
      end

      context 'when gender' do
        context 'when magnitude is odd' do
          Array(0..9).select(&:odd?).each do |odd_number|
            specify { TrangeFrange::One.new('121', odd_number).word.should eq('jedna') }
            specify { TrangeFrange::One.new('122', odd_number).word.should eq('dve') }
          end
        end

        context 'when magnitude is even' do
          Array(0..9).select(&:even?).each do |even_number|
            specify { TrangeFrange::One.new('121', even_number).word.should eq('jedan') }
            specify { TrangeFrange::One.new('122', even_number).word.should eq('dva') }
          end
        end
      end

      context 'when teen' do
        specify { TrangeFrange::One.new('110', 0).word.should be_empty }
        specify { TrangeFrange::One.new('111', 0).word.should be_empty }
        specify { TrangeFrange::One.new('112', 1).word.should be_empty }
        specify { TrangeFrange::One.new('113', 2).word.should be_empty }
        specify { TrangeFrange::One.new('114', 3).word.should be_empty }
        specify { TrangeFrange::One.new('115', 4).word.should be_empty }
        specify { TrangeFrange::One.new('116', 5).word.should be_empty }
        specify { TrangeFrange::One.new('117', 6).word.should be_empty }
        specify { TrangeFrange::One.new('118', 7).word.should be_empty }
        specify { TrangeFrange::One.new('119', 2).word.should be_empty }
      end
    end
  end

  describe TrangeFrange::Ten do
    describe 'private #teen_base_member' do
      specify do
        TrangeFrange::Ten.new('103').send(:teen_base_member).should eq('03')
      end
      specify do 
        TrangeFrange::Ten.new('113').send(:teen_base_member).should eq('13')
      end
      specify do 
        TrangeFrange::Ten.new('123').send(:teen_base_member).should eq('23')
      end
    end

    describe '#word' do
      context 'when simple' do
        specify { TrangeFrange::Ten.new('103').word.should eq(String.new) }
        specify { TrangeFrange::Ten.new('123').word.should eq('dvadeset') }
        specify { TrangeFrange::Ten.new('134').word.should eq('trideset') }
        specify { TrangeFrange::Ten.new('145').word.should eq('četrdeset') }
        specify { TrangeFrange::Ten.new('156').word.should eq('pedeset') }
        specify { TrangeFrange::Ten.new('167').word.should eq('šezdeset') }
        specify { TrangeFrange::Ten.new('178').word.should eq('sedamdeset') }
        specify { TrangeFrange::Ten.new('189').word.should eq('osamdeset') }
        specify { TrangeFrange::Ten.new('199').word.should eq('devedeset') }
      end

      context 'when teen' do
        specify { TrangeFrange::Ten.new('111').word.should eq('jedanaest') }
        specify { TrangeFrange::Ten.new('112').word.should eq('dvanaest') }
        specify { TrangeFrange::Ten.new('113').word.should eq('trinaest') }
        specify { TrangeFrange::Ten.new('114').word.should eq('četrnaest') }
        specify { TrangeFrange::Ten.new('115').word.should eq('petnaest') }
        specify { TrangeFrange::Ten.new('116').word.should eq('šesnaest') }
        specify { TrangeFrange::Ten.new('117').word.should eq('sedamnaest') }
        specify { TrangeFrange::Ten.new('118').word.should eq('osamnaest') }
        specify { TrangeFrange::Ten.new('119').word.should eq('devetnaest') }
      end
    end
  end

  describe TrangeFrange::Hundred do
    describe '#word' do
      specify { TrangeFrange::Hundred.new('013').word.should eq(String.new) }
      specify { TrangeFrange::Hundred.new('113').word.should eq('jedna stotina') }
      specify { TrangeFrange::Hundred.new('223').word.should eq('dve stotine') }
      specify { TrangeFrange::Hundred.new('334').word.should eq('tri stotine') }
      specify { TrangeFrange::Hundred.new('445').word.should eq('četiri stotine') }
      specify { TrangeFrange::Hundred.new('556').word.should eq('pet stotina') }
      specify { TrangeFrange::Hundred.new('667').word.should eq('šest stotina') }
      specify { TrangeFrange::Hundred.new('778').word.should eq('sedam stotina') }
      specify { TrangeFrange::Hundred.new('889').word.should eq('osam stotina') }
      specify { TrangeFrange::Hundred.new('999').word.should eq('devet stotina') }
    end
  end

  describe TrangeFrange::Thousand do
    describe '#word' do
      context 'when gender' do
        context 'when teen' do
          specify { TrangeFrange::Thousand.new('112').word.should eq('hiljada') }
          specify { TrangeFrange::Thousand.new('113').word.should eq('hiljada') }
          specify { TrangeFrange::Thousand.new('114').word.should eq('hiljada') }
        end

        context 'when not teen' do
          specify { TrangeFrange::Thousand.new('122').word.should eq('hiljade') }
          specify { TrangeFrange::Thousand.new('123').word.should eq('hiljade') }
          specify { TrangeFrange::Thousand.new('124').word.should eq('hiljade') }
        end
      end

      context 'when simple non gender teen' do
        specify { TrangeFrange::Thousand.new('110').word.should eq('hiljada') }
        specify { TrangeFrange::Thousand.new('111').word.should eq('hiljada') }
        specify { TrangeFrange::Thousand.new('115').word.should eq('hiljada') }
        specify { TrangeFrange::Thousand.new('116').word.should eq('hiljada') }
        specify { TrangeFrange::Thousand.new('117').word.should eq('hiljada') }
        specify { TrangeFrange::Thousand.new('118').word.should eq('hiljada') }
        specify { TrangeFrange::Thousand.new('119').word.should eq('hiljada') }
      end

      context 'when simple non gender not teen' do
        specify { TrangeFrange::Thousand.new('120').word.should eq('hiljada') }
        specify { TrangeFrange::Thousand.new('231').word.should eq('hiljada') }
        specify { TrangeFrange::Thousand.new('345').word.should eq('hiljada') }
        specify { TrangeFrange::Thousand.new('456').word.should eq('hiljada') }
        specify { TrangeFrange::Thousand.new('567').word.should eq('hiljada') }
        specify { TrangeFrange::Thousand.new('678').word.should eq('hiljada') }
        specify { TrangeFrange::Thousand.new('789').word.should eq('hiljada') }
      end
    end
  end

  describe TrangeFrange::Milion do
    describe '#word' do
      context 'when one' do
        context 'when not teen' do
          specify { TrangeFrange::Milion.new('101').word.should eq('milion') }
          specify { TrangeFrange::Milion.new('121').word.should eq('milion') }
        end
      end

      context 'when other' do
        specify { TrangeFrange::Milion.new('110').word.should eq('miliona') }
        specify { TrangeFrange::Milion.new('111').word.should eq('miliona') }
        specify { TrangeFrange::Milion.new('112').word.should eq('miliona') }
        specify { TrangeFrange::Milion.new('123').word.should eq('miliona') }
        specify { TrangeFrange::Milion.new('134').word.should eq('miliona') }
        specify { TrangeFrange::Milion.new('145').word.should eq('miliona') }
        specify { TrangeFrange::Milion.new('156').word.should eq('miliona') }
        specify { TrangeFrange::Milion.new('167').word.should eq('miliona') }
        specify { TrangeFrange::Milion.new('178').word.should eq('miliona') }
        specify { TrangeFrange::Milion.new('189').word.should eq('miliona') }
      end
    end
  end

  describe TrangeFrange::Bilion do
    describe '#word' do
      context 'when one' do
        context 'when not teen' do
          specify { TrangeFrange::Bilion.new('101').word.should eq('milijarda') }
          specify { TrangeFrange::Bilion.new('121').word.should eq('milijarda') }
        end
      end

      context 'when gender' do
        context 'when not teen' do
          specify { TrangeFrange::Bilion.new('102').word.should eq('milijarde') }
          specify { TrangeFrange::Bilion.new('123').word.should eq('milijarde') }
          specify { TrangeFrange::Bilion.new('134').word.should eq('milijarde') }
        end
      end

      context 'when other' do
        specify { TrangeFrange::Bilion.new('110').word.should eq('milijardi') }
        specify { TrangeFrange::Bilion.new('111').word.should eq('milijardi') }
        specify { TrangeFrange::Bilion.new('112').word.should eq('milijardi') }
        specify { TrangeFrange::Bilion.new('145').word.should eq('milijardi') }
        specify { TrangeFrange::Bilion.new('156').word.should eq('milijardi') }
        specify { TrangeFrange::Bilion.new('167').word.should eq('milijardi') }
        specify { TrangeFrange::Bilion.new('178').word.should eq('milijardi') }
        specify { TrangeFrange::Bilion.new('189').word.should eq('milijardi') }
      end
    end
  end

  describe TrangeFrange::Shaper do
    let!(:words) { 'jedna stotina dvadeset tri hiljade četiri stotine pedeset šest' }

    specify do 
      TrangeFrange::Shaper.new(words, 75, {}).shape!.should \
        eq('jedna stotina dvadeset tri hiljade četiri stotine pedeset šest')
    end
    specify do 
      TrangeFrange::Shaper.new(words, 75, show_fraction: true).shape!.should \
        eq("jedna stotina dvadeset tri hiljade četiri stotine pedeset šest i 75/100")
    end
    specify do 
      TrangeFrange::Shaper.new(words, 75, show_fraction: true, squeeze: true).shape!.should \
        eq("jednastotinadvadesettrihiljadečetiristotinepedesetšest i 75/100")
    end
    specify do 
      TrangeFrange::Shaper.new(words, 75, show_fraction: true, squeeze: true, bald: true).shape!.should \
        eq("jednastotinadvadesettrihiljadecetiristotinepedesetsest i 75/100")
    end
  end

  describe TrangeFrange::Amount do
    describe '#amount' do
      context 'when valid amount' do
        specify do
          amount = TrangeFrange::Amount.new 123
          amount.amount.should eq(123)
        end

        specify do
          amount = TrangeFrange::Amount.new 123.45
          amount.amount.should eq(123.45)
        end
      end

      context 'when invalid amount' do
        specify 'raise an exception' do
          expect { TrangeFrange::Amount.new('123') }.to \
            raise_error(TypeError, 'Amount must be of type Fixnum or Float.')
        end
        specify 'raise an exception' do
          expect { TrangeFrange::Amount.new(1234657981234) }.to \
            raise_error(NotImplementedError, 'I can only work with amounts up to 999 bilions.')
        end
      end
    end

    describe '#spell!' do
      context 'when valid amount' do
        context 'when options are ommited' do
          specify do
            amount = TrangeFrange::Amount.new 123456.78
            amount.spell!.should eq('jedna stotina dvadeset tri hiljade četiri stotine pedeset šest')
          end
        end

        context 'when `show_fraction` option is true' do
          specify do
            amount = TrangeFrange::Amount.new 123456.78
            amount.spell!(show_fraction: true).should eq('jedna stotina dvadeset tri hiljade četiri stotine pedeset šest i 78/100')
          end
        end

        context 'when `show_fraction` option is false' do
          specify do
            amount = TrangeFrange::Amount.new 123456.78
            amount.spell!(show_fraction: false).should eq('jedna stotina dvadeset tri hiljade četiri stotine pedeset šest')
          end
        end

        context 'when `squeeze` option is true' do
          specify do
            amount = TrangeFrange::Amount.new 123456.78
            amount.spell!(squeeze: true).should eq('jednastotinadvadesettrihiljadečetiristotinepedesetšest')
          end
        end

        context 'when `bald` option is true' do
          specify do
            amount = TrangeFrange::Amount.new 123456.78
            amount.spell!(bald: true).should eq('jedna stotina dvadeset tri hiljade cetiri stotine pedeset sest')
          end
        end

        context 'when options are combined' do
          specify do
            amount = TrangeFrange::Amount.new 123456.78
            amount.spell!(show_fraction: true, squeeze: true, bald: true).should \
              eq('jednastotinadvadesettrihiljadecetiristotinepedesetsest i 78/100')
          end
        end

        specify do
          amount = TrangeFrange::Amount.new 1
          amount.spell!(show_fraction: true).should eq('jedan i 00/100')
        end
        specify do
          amount = TrangeFrange::Amount.new 12.34
          amount.spell!(show_fraction: true).should eq('dvanaest i 34/100')
        end
        specify do
          amount = TrangeFrange::Amount.new 123.45
          amount.spell!(show_fraction: true).should eq('jedna stotina dvadeset tri i 45/100')
        end
        specify do
          amount = TrangeFrange::Amount.new 1234.56
          amount.spell!(show_fraction: true).should eq('jedna hiljada dve stotine trideset četiri i 56/100')
        end
        specify do
          amount = TrangeFrange::Amount.new 12345.67
          amount.spell!(show_fraction: true).should eq('dvanaest hiljada tri stotine četrdeset pet i 67/100')
        end
        specify do
          amount = TrangeFrange::Amount.new 123456.78
          amount.spell!(show_fraction: true).should eq('jedna stotina dvadeset tri hiljade četiri stotine pedeset šest i 78/100')
        end
        specify do
          amount = TrangeFrange::Amount.new 1234567.89
          amount.spell!(show_fraction: true).should eq('jedan milion dve stotine trideset četiri hiljade pet stotina šezdeset sedam i 89/100')
        end
        specify do
          amount = TrangeFrange::Amount.new 12345678
          amount.spell!(show_fraction: true).should eq('dvanaest miliona tri stotine četrdeset pet hiljada šest stotina sedamdeset osam i 00/100')
        end
        specify do
          amount = TrangeFrange::Amount.new 123456789
          amount.spell!(show_fraction: true).should eq('jedna stotina dvadeset tri miliona četiri stotine pedeset šest hiljada sedam stotina osamdeset devet i 00/100')
        end
        specify do
          amount = TrangeFrange::Amount.new 1234567890
          amount.spell!(show_fraction: true).should eq('jedna milijarda dve stotine trideset četiri miliona pet stotina šezdeset sedam hiljada osam stotina devedeset i 00/100')
        end
        specify do
          amount = TrangeFrange::Amount.new 12345678901
          amount.spell!(show_fraction: true).should eq('dvanaest milijardi tri stotine četrdeset pet miliona šest stotina sedamdeset osam hiljada devet stotina jedan i 00/100')
        end
        specify do
          amount = TrangeFrange::Amount.new 123456789012
          amount.spell!(show_fraction: true).should eq('jedna stotina dvadeset tri milijarde četiri stotine pedeset šest miliona sedam stotina osamdeset devet hiljada dvanaest i 00/100')
        end
      end
    end

    describe 'PRIVATE' do
      describe '#split!' do
        specify do
          amount = TrangeFrange::Amount.new 12345
          amount.send(:split!).should eq(['12345', '00'])
        end

        specify do
          amount = TrangeFrange::Amount.new 12345.67
          amount.send(:split!).should eq(['12345', '67'])
        end

        specify do
          amount = TrangeFrange::Amount.new 12345.678
          amount.send(:split!).should eq(['12345', '68'])
        end
      end

      describe '#whole_number' do
        specify { TrangeFrange::Amount.new(12345.67).send(:whole_number).should eq('12345') }
      end

      describe '#fraction' do
        specify { TrangeFrange::Amount.new(12345.678).send(:fraction).should eq('68') }
      end

      describe '#generate_base!' do
        specify do
          amount = TrangeFrange::Amount.new 123
          amount.send(:generate_base!, '123', 0).should \
            eq('jedna stotina dvadeset tri')
        end
      end

      describe '#generate_suffix!' do
        context 'when magnitude is greater than zero' do
          specify do
            amount = TrangeFrange::Amount.new 123000
            amount.send(:generate_suffix!, '123', 1).should eq('hiljade')
          end
        end

        context 'when magnitude is zero' do
          specify do
            amount = TrangeFrange::Amount.new 123
            amount.send(:generate_suffix!, '123', 0).should eq(String.new)
          end
        end
      end

      describe '#members' do
        specify do
          amount = TrangeFrange::Amount.new 1234567.89
          amount.send(:members).should match_array(['1', '234', '567'])
        end
      end

      describe '#generate_words' do
        specify do
          amount = TrangeFrange::Amount.new 12345.67
          amount.send(:generate_words!).should eq('dvanaest hiljada tri stotine četrdeset pet')
        end
      end
    end
  end
end
