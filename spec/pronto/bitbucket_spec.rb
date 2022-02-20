module Pronto
  describe Bitbucket do
    let(:bitbucket) { described_class.new(repo) }

    let(:repo) do
      double(remote_urls: ['git@bitbucket.org:prontolabs/pronto.git'],
             branch: nil)
    end
    let(:sha) { '61e4bef' }
    let(:comment) do
      double(content: 'note', filename: 'path', line_to: 1, position: 1, id: 1)
    end

    describe '#slug' do
      let(:repo) { double(remote_urls: ['git@bitbucket.org:prontolabs/pronto']) }
      subject { bitbucket.commit_comments(sha) }

      context 'git remote without .git suffix' do
        specify do
          BitbucketClient.any_instance
            .should_receive(:commit_comments)
            .with('prontolabs/pronto', sha)
            .once
            .and_return([comment])

          subject
        end
      end
    end

    describe '#commit_comments' do
      subject { bitbucket.commit_comments(sha) }

      context 'three requests for same comments' do
        specify do
          BitbucketClient.any_instance
            .should_receive(:commit_comments)
            .with('prontolabs/pronto', sha)
            .once
            .and_return([comment])

          subject
          subject
          subject
        end
      end
    end

    describe '#pull_comments' do
      subject { bitbucket.pull_comments(sha) }

      context 'three requests for same comments' do
        specify do
          BitbucketClient.any_instance
            .should_receive(:pull_requests)
            .once
            .and_return([])

          BitbucketClient.any_instance
            .should_receive(:pull_comments)
            .with('prontolabs/pronto', 10)
            .once
            .and_return([comment])

          ENV['PRONTO_PULL_REQUEST_ID'] = '10'

          subject
          subject
          subject
        end
      end
    end
  end
end
