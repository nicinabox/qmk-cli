module QMK
  class Git
    def initialize(repo_path)
      @repo_path = repo_path
    end

    def path
      @repo_path
    end

    def ensure_path_exists
      `mkdir -p #{@repo_path}`
    end

    def clone(repo)
      ensure_path_exists
      `git clone #{repo} #{@repo_path}`
    end

    def fetch_origin
      `git fetch origin master`
    end

    def checkout_latest_tag
      `git checkout #{latest_tag}`
    end

    def latest_tag
      `git describe --tags $(git rev-list --tags --max-count=1)`
    end

    def clean
      `git checkout .`
      `git clean -df`
    end

    def in_repo(&block)
      Dir.chdir @repo_path, &block
    end
  end
end
