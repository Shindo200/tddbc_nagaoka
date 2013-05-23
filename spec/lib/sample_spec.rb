# -*- encoding: utf-8 -*-
require 'spec_helper'

describe "Version" do
  describe ".valid?" do
    it "正規のバージョンを表す文字列を渡したときはTrueを返すこと" do
      Version.valid?("JDK7u40").should be_true
    end

    it "正規のバージョンを表さない文字列を渡したときはFalseを返すこと" do
      Version.valid?("hoge").should be_false
      Version.valid?("fuga").should be_false
      Version.valid?("JDK7u9x").should be_false
    end
  end

  describe ".parse" do
    it "family_numberとupdate_numberメソッドを実行できるオブジェクトを返すこと" do
      Version.parse("JDK7u40").should respond_to("family_number", "update_number")
    end

    it "正規のバージョンを表さない文字列を渡したときは例外を返すこと" do
      proc { Version.parse("JDK7u4x")}.should raise_error
    end
  end

  context "バージョン値を持っているとき" do
    before do
      @f6u60 = Version.new("JDK6u60")
      @f7u35 = Version.new("JDK7u35")
      @f7u40 = Version.new("JDK7u40")
      @f7u51 = Version.new("JDK7u51")
      @f8u00 = Version.new("JDK8u00")
    end

    describe "#family_number" do
      it "ファミリーナンバーを返すこと" do
        @f7u40.family_number.should eq 7
        @f8u00.family_number.should eq 8
      end
    end

    describe "#update_number" do
      it "アップデートナンバーを返すこと" do
        @f7u40.update_number.should eq 40
        @f7u35.update_number.should eq 35
      end
    end

    describe "#lt" do
      it "自分より大きいアップデートナンバーを持つVersionを渡したときはtrueを返すこと" do
        @f7u40.lt(@f7u51).should be_true
      end

      it "自分より小さいアップデートナンバーを持つVersionを渡したときはfalseを返すこと" do
        @f7u40.lt(@f7u35).should be_false
      end

      it "自分より大きいファミリーナンバーを持つVersionを渡したときはtrueを返すこと" do
        @f7u40.lt(@f8u00).should be_true
      end

      it "自分より小さいファミリーナンバーを持つVersionを渡したときはfalseを返すこと" do
        @f7u40.lt(@f6u60).should be_false
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
        @f7u40.gt(@f8u00).should be_false
      end
    end
  end
end
