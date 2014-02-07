module EpisodesCellStylesheet
  def cell_size
    {w: rmq.device.width, h: 96}
  end

  def episodes_cell(st)
    st.frame = cell_size
    st.background_color = color.random

    # Style overall view here
  end

  def title(st)
    st.frame = cell_size
  end

end
