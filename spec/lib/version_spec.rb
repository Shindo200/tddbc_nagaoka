require 'spec_helper'

describe "Version" do
  describe ".valid?" do
    it "正当なバージョンを表す文字列を渡したときはTrueを返すこと" do
      Version.valid?("JDK7u40").should be_true
    end

    it "正当なバージョンを表さない文字列を渡したときはFalseを返すこと" do
      Version.valid?("hoge").should be_false
      Version.valid?("fuga").should be_false
      Version.valid?("JDK7u9x").should be_false
    end
  end

  describe ".parse" do
    it "family_numberとupdate_numberメソッドを実行できるオブジェクトを返すこと" do
      Version.parse("JDK7u40").should respond_to("family_number", "update_number")
    end

    it "返されたオブジェクトに正しいfamily_numberがセットされていること" do
      Version.parse("JDK7u40").family_number.should eq 7
      Version.parse("JDK8u20").family_number.should eq 8
    end

    it "返されたオブジェクトに正しいupdate_numberがセットされていること" do
      Version.parse("JDK7u40").update_number.should eq 40
      Version.parse("JDK8u20").update_number.should eq 20
    end

    it "正当なバージョンを表さない文字列を渡したときは例外を返すこと" do
      proc { Version.parse("JDK7u4x")}.should raise_error
    end
  end

  context "バージョン値を持っているとき" do
    before do
      @f6u60 = Version.parse("JDK6u60")
      @f7u35 = Version.parse("JDK7u35")
      @f7u40 = Version.parse("JDK7u40")
      @f7u40_more = Version.parse("JDK7u40")
      @f7u51 = Version.parse("JDK7u51")
      @f8u05 = Version.parse("JDK8u05")
    end

    describe "#lt" do
      it "自分より大きいアップデートナンバーを持つVersionを渡したときはtrueを返すこと" do
        @f7u40.lt(@f7u51).should be_true
      end

      it "自分より小さいアップデートナンバーを持つVersionを渡したときはfalseを返すこと" do
        @f7u40.lt(@f7u35).should be_false
      end

      it "自分より大きいファミリーナンバーを持つVersionを渡したときはtrueを返すこと" do
        @f7u40.lt(@f8u05).should be_true
      end

      it "自分より小さいファミリーナンバーを持つVersionを渡したときはfalseを返すこと" do
        @f7u40.lt(@f6u60).should be_false
      end

      it "同じバージョンを持つVersionを渡したときはfalseを返すこと" do
        @f7u40.lt(@f7u40_more).should be_false
      end
    end

    describe "#gt" do
      it "自分より小さいアップデートナンバーを持つVersionを渡したときはtrueを返すこと" do
        @f7u40.gt(@f7u35).should be_true
      end

      it "自分より大きいアップデートナンバーを持つVersionを渡したときはfalseを返すこと" do
        @f7u40.gt(@f7u51).should be_false
      end

      it "自分より小さいファミリーナンバーを持つVersionを渡したときはtrueを返すこと" do
        @f7u40.gt(@f6u60).should be_true
      end

      it "自分より大きいファミリーナンバーを持つVersionを渡したときはfalseを返すこと" do
        @f7u40.gt(@f8u05).should be_false
      end

      it "同じバージョンを持つVersionを渡したときはfalseを返すこと" do
        @f7u40.lt(@f7u40_more).should be_false
      end
    end

    describe "#next_limited_update" do
      it "次のLimitedUpdateの番号を持つVersionを返すこと" do
        @f7u40.next_limited_update.update_number.should eq 60
        @f8u05.next_limited_update.update_number.should eq 20
      end

      it "自分自身のバージョンは変わらないこと" do
        @f7u40.next_limited_update
        @f7u40.update_number.should eq 40
      end
    end

    describe "#next_critical_patch_update" do
      it "次のCriticalPatchUpdateの番号を持つVersionを返すこと" do
        @f7u40.next_critical_patch_update.update_number.should eq 45
        @f8u05.next_critical_patch_update.update_number.should eq 11
      end

      it "自分自身のバージョンは変わらないこと" do
        @f7u40.next_critical_patch_update
        @f7u40.update_number.should eq 40
      end
    end

    describe "#next_security_alert" do
      it "次のSecurityAlertUpdateの番号を持つVersionを返すこと" do
        @f8u05.next_security_alert.update_number.should eq 6
      end

      it "自分自身のバージョンは変わらないこと" do
        @f7u40.next_security_alert
        @f7u40.update_number.should eq 40
      end
    end
  end
end
