require 'test_helper'

describe Hbc::CLI::Audit do
  let(:auditor) { mock() }
  let(:cask) { mock() }

  describe 'selection of Casks to audit' do
    it 'audits all Casks if no tokens are given' do
      Hbc.stubs(:all => [cask, cask])
      auditor.expects(:audit).times(2)

      run_audit([], auditor)
    end

    it 'audits specified Casks if tokens are given' do
      cask_token = 'nice-app'
      Hbc.expects(:load).with(cask_token).returns(cask)
      auditor.expects(:audit).with(cask, :audit_download => false)

      run_audit([cask_token], auditor)
    end
  end

  describe 'rules for downloading a Cask' do
    it 'does not download the Cask per default' do
      Hbc.stubs(:load => cask)

      auditor.expects(:audit).with(cask, :audit_download => false)

      run_audit(['casktoken'], auditor)
    end

    it 'download a Cask if --download flag is set' do
      Hbc.stubs(:load => cask)

      auditor.expects(:audit).with(cask, :audit_download => true)

      run_audit(['casktoken', '--download'], auditor)
    end
  end

  def run_audit(args, auditor)
    Hbc::CLI::Audit.new(args, auditor).run
  end
end
