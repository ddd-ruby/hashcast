require 'spec_helper'

describe "Casters" do
  context HashCast::Casters::ArrayCaster do
    def cast(v)
      HashCast::Casters::ArrayCaster.cast(v, :attr_name)
    end

    it "works with real values" do
      expect(cast([true])).to eq([true])
    end

    it "works with given caster" do
      expect(
        HashCast::Casters::ArrayCaster.cast(["true"], :attr_name, {each: :boolean})
      ).to eq([true])
    end

    it "raises else with wrong values" do
      expect{
        cast("something")
      }.to raise_error(HashCast::Errors::CastingError)
    end

    it "raises when given caster does not exist" do
      expect{
        HashCast::Casters::ArrayCaster.cast(["true"], :attr_name, {each: :booleans})
      }.to raise_error(HashCast::Errors::CasterNotFoundError, "caster with name booleans is not found")
    end
  end

  context HashCast::Casters::BooleanCaster do
    def cast(v)
      HashCast::Casters::BooleanCaster.cast(v, :attr_name)
    end
    it "works with real booleans" do
      expect(cast(true)).to eq(true)
      expect(cast(false)).to eq(false)
    end

    it "works with trueish values" do
      expect(cast(1)).to eq(true)
      expect(cast("1")).to eq(true)
      expect(cast("on")).to eq(true)
      expect(cast("true")).to eq(true)
    end

    it "works with falsish values" do
      expect(cast("0")).to eq(false)
      expect(cast("false")).to eq(false)
      expect(cast("off")).to eq(false)
      expect(cast(0)).to eq(false)
    end

    it "raises else with wrong values" do
      expect{
        cast("something")
      }.to raise_error(HashCast::Errors::CastingError)
    end
  end

  context HashCast::Casters::DateCaster do
    def cast(v)
      HashCast::Casters::DateCaster.cast(v, :attr_name)
    end
    it "works with real dates" do
      value = Date.new
      expect(cast(value)).to eq(value)
    end

    it "works with proper string dates" do
      value = "2016/10/30"
      expect(cast(value)).to eq(Date.new(2016, 10, 30))
    end

    it "raises else with wrong string value" do
      expect{
        cast("something")
      }.to raise_error(HashCast::Errors::CastingError)
    end

    it "raises else" do
      expect{
        cast(1)
      }.to raise_error(HashCast::Errors::CastingError)
    end
  end

  context HashCast::Casters::DateTimeCaster do
    def cast(v)
      HashCast::Casters::DateTimeCaster.cast(v, :attr_name)
    end

    it "works with real datetimes" do
      value = DateTime.new
      expect(cast(value)).to eq(value)
    end

    it "works with proper string datetimes" do
      value = "2016-10-30T14:20:30+00:00"
      expect(cast(value)).to eq(DateTime.new(2016, 10, 30, 14, 20, 30))
    end

    it "raises else with wrong string value" do
      expect{
        cast("something")
      }.to raise_error(HashCast::Errors::CastingError)
    end

    it "raises else" do
      expect{
        cast(1)
      }.to raise_error(HashCast::Errors::CastingError)
    end
  end

  context HashCast::Casters::FloatCaster do
    def cast(v)
      HashCast::Casters::FloatCaster.cast(v, :attr_name)
    end

    it "works with real values" do
      value = 1.4
      expect(cast(value)).to eq(value)
    end

    it "works with proper string floats" do
      value = "1.3"
      expect(cast(value)).to eq(1.3)
    end

    it "raises else with wrong string value" do
      expect{
        cast("something")
      }.to raise_error(HashCast::Errors::CastingError)
    end

    it "raises else" do
      expect{
        cast(1)
      }.to raise_error(HashCast::Errors::CastingError)
    end
  end

  context HashCast::Casters::HashCast do
    def cast(v)
      HashCast::Casters::HashCast.cast(v, :attr_name)
    end

    it "works with real values" do
      value = {a: 1}
      expect(cast(value)).to eq(value)
    end

    it "raises else" do
      expect{
        cast(1)
      }.to raise_error(HashCast::Errors::CastingError)
    end
  end

  context HashCast::Casters::IntegerCaster do
    def cast(v)
      HashCast::Casters::IntegerCaster.cast(v, :attr_name)
    end

    it "works with real value" do
      value = 5
      expect(cast(value)).to eq(value)
    end

    it "works with proper string values" do
      expect(cast("5")).to eq(5)
    end

    it "raises with invalid string values" do
      expect{
        cast("some")
      }.to raise_error(HashCast::Errors::CastingError)
    end

    it "raises else" do
      expect{
        cast(1.3)
      }.to raise_error(HashCast::Errors::CastingError)
    end
  end


  context HashCast::Casters::TimeCaster do
    def cast(v)
      HashCast::Casters::TimeCaster.cast(v, :attr_name)
    end

    it "works with real value" do
      value = Time.new
      expect(cast(value)).to eq(value)
    end

    it "works with proper string values" do
      expect(cast("12:30:15")).to eq(Time.parse("12:30:15"))
    end

    it "raises with invalid string values" do
      expect{
        cast("some")
      }.to raise_error(HashCast::Errors::CastingError)
    end

    it "raises else" do
      expect{
        cast(1.3)
      }.to raise_error(HashCast::Errors::CastingError)
    end
  end


  context HashCast::Casters::SymbolCaster do
    def cast(v)
      HashCast::Casters::SymbolCaster.cast(v, :attr_name)
    end

    it "works with real value" do
      value = :symbol
      expect(cast(value)).to eq(value)
    end

    it "works with proper string values" do
      expect(cast("symbol")).to eq(:symbol)
    end

    it "raises with long strings" do
      expect{
        cast("a" * (HashCast::Casters::SymbolCaster::MAX_SYMBOL_LENGTH + 1))
      }.to raise_error(HashCast::Errors::CastingError)
    end

    it "raises else" do
      expect{
        cast(1.3)
      }.to raise_error(HashCast::Errors::CastingError)
    end
  end

end
