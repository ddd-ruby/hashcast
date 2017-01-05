require 'spec_helper'

describe HashCast do

  describe ".create" do
    it "should cast hash attributes" do
      pending "NOT YET IMPLEMENTED"
      input_hash = {
        contact: {
          name: "John Smith",
          age: "22",
          company: {
            name: "MyCo",
          }
        }
      }

      caster = HashCast.create do
        hash :contact do
          string   :name
          integer  :age
          hash :company do
            string :name
          end
        end

        def registered?
          true
        end
      end

      casted_hash = caster.cast(input_hash)
      casted_hash.object_id.should_not == hash.object_id
      caster_hash.should == hash
    end
  end
end
