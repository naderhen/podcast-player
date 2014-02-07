class EpisodesController < UICollectionViewController
  attr_accessor :episodes
  # In app_delegate.rb or wherever you use this controller, just call .new like so:
  #   @window.rootViewController = EpisodesController.new
  #
  # Or if you're adding using it in a navigation controller, do this
  #  main_controller = EpisodesController.new
  #  @window.rootViewController = UINavigationController.alloc.initWithRootViewController(main_controller)
  FEED_URL = "http://www.thecurrent.org/collection/song-of-the-day/rss"
  EPISODES_CELL_ID = "EpisodesCell"
  
  def self.new(args = {})
    # Set layout 
    layout = UICollectionViewFlowLayout.alloc.init
    self.alloc.initWithCollectionViewLayout(layout)
  end

  def viewDidLoad
    super

    @episodes = []

    self.title = "Songs"

    loadEpisodes

    rmq.stylesheet = EpisodesControllerStylesheet

    collectionView.tap do |cv|
      cv.registerClass(EpisodesCell, forCellWithReuseIdentifier: EPISODES_CELL_ID)
      cv.delegate = self
      cv.dataSource = self
      cv.allowsSelection = true
      cv.allowsMultipleSelection = false
      rmq(cv).apply_style :collection_view
    end

    if UIApplication.sharedApplication.respondsToSelector('beginReceivingRemoteControlEvents')
      UIApplication.sharedApplication.beginReceivingRemoteControlEvents
    end
    AVAudioSession.sharedInstance.setDelegate(self)
    AVAudioSession.sharedInstance.setCategory(AVAudioSessionCategoryPlayback, error:nil)
    AVAudioSession.sharedInstance.setActive(true, error:nil)
  end

  def viewDidAppear(animated)
    super
    self.becomeFirstResponder
  end

  def viewWillDisappear(animated)
    super
    self.resignFirstResponder
  end

  def canBecomeFirstResponder
    true
  end

  def loadEpisodes
    feed_parser = BW::RSSParser.new(FEED_URL)
    feed_parser.delegate = self
    feed_parser.parse do |item|
      @episodes << item
    end
  end

  def when_parser_is_done
   collectionView.reloadData
  end

  # Remove if you are only supporting portrait
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end

  # Remove if you are only supporting portrait
  def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
    rmq(:reapply_style).reapply_styles
  end

  def numberOfSectionsInCollectionView(view)
    1
  end
 
  def collectionView(view, numberOfItemsInSection: section)
   @episodes.size 
  end
    
  def collectionView(view, cellForItemAtIndexPath: index_path)
    view.dequeueReusableCellWithReuseIdentifier(EPISODES_CELL_ID, forIndexPath: index_path).tap do |cell|
      rmq.build(cell) unless cell.reused

      # Update cell's data here
      cell.update(@episodes[index_path.row])
    end
  end

  def collectionView(view, didSelectItemAtIndexPath: index_path)
    cell = view.cellForItemAtIndexPath(index_path)
    episode = @episodes[index_path.row]
    url = episode.enclosure["url"]
    BW::Media.play(url) do |media_player|
      ap "playing"
    end
  end


  def remoteControlReceivedWithEvent(event)
    NSLog(event.subtype.to_s)
    if event.subtype == UIEventSubtypeRemoteControlTogglePlayPause
      playOrStop(nil)
    end
 
    if event.subtype == UIEventSubtypeRemoteControlPlay
      playOrStop(nil)
    end
 
    if event.subtype == UIEventSubtypeRemoteControlPause
      playOrStop(nil)
    end
 
    if event.subtype == UIEventSubtypeRemoteControlStop
      playOrStop(nil)
    end
    
    #if event.subtype == UIEventSubtypeRemoteControlNextTrack
    # fastForward
    #end
 
    #if event.subtype == UIEventSubtypeRemoteControlRewind
    # rewind
    #end  
      
  end 
 
  def playOrStop(sender)
    NSLog("PLAYORSTOP")
    # status = @radio_kit.getStreamStatus
    # if (status == SRK_STATUS_STOPPED || status == SRK_STATUS_PAUSED)
    #   @radio_kit.startStream
    # elsif status == SRK_STATUS_PLAYING
    #   @radio_kit.pauseStream
    # else
    #   @radio_kit.stopStream
    # end
   
  end   

end
