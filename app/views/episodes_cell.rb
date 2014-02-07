class EpisodesCell < UICollectionViewCell 
  attr_reader :reused
  attr_accessor :episode

  def rmq_build
    rmq(self).apply_style :episodes_cell

    rmq(self.contentView).tap do |q|
      @title = rmq.append(UILabel, :title)
    end
  end

  def updateLayout
    @title.get.text = @episode.title
  end

  def prepareForReuse
    @reused = true
  end

  def update(episode)
    @episode = episode
    updateLayout
  end
end
