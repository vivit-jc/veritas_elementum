class View

  def initialize(game,controller)
    @game = game
    @controller = controller

    @material = @game.material

    @clock = Image.new(MAIN_MENU_WIDTH, CLOCK_HEIGHT)
    @clock.box(3, 3, MAIN_MENU_WIDTH-4, CLOCK_HEIGHT-4, WHITE)
    @iconback = Image.new(64,64)
    @iconback.box_fill(0,0,64,64,WHITE)
    @iconback_s = Image.new(32,32)
    @iconback_s.box_fill(0,0,32,32,WHITE)
    @placeback = Image.new(150,30)
    @placeback.box(1,1,148,28,WHITE)
    
  end

  def draw
    draw_xy
    draw_debug
    case @game.status
    when :title
      draw_title
    when :game
      draw_game
    when :stats
      draw_stats
    end
  end

  def draw_title
    Window.draw(0,0,Image[:title])
    Window.draw_font(30, 240, "VERITAS, ELEMENTUM", Font50, {color: YELLOW})
    
    TITLE_MENU_TEXT.each_with_index do |menu,i|
      Window.draw_font(TITLE_MENU_X,TITLE_MENU_Y[i],menu,Font32,mouseover_color(@controller.pos_title_menu == i, YELLOW)) 
    end
  end

  def draw_game
    draw_main_menu if @game.place_now == :home
    draw_schedule
    draw_health
    draw_message(@game.message)
    case @game.game_status
    when :experiment
      draw_experiment
    when :note
      draw_note_view
    when :go_out
      if @game.place_now == :home
        draw_go_out
      else
        draw_places_menu
        draw_place
      end
    when :material
      draw_materials_view
    when :rest
      draw_rest
    end

  end

  def draw_experiment
    case(@game.mainview_status)
    when :set_materials
      draw_set_materials
    when :materials_view
      draw_materials_view 
    when :experiment_result
      draw_experiment_result
    when :reagents_view
      draw_reagents_view
    end

  end

  def draw_materials_view
    page = @game.page
    if @game.game_status == :experiment
      @material.have_materials.select{|k,v|v>0}.each_with_index do |(k,v),i|
        next if v == 0
        draw_materials_view_core(k,i)
      end
    elsif @game.game_status == :material
      MATERIALS.each_with_index do |(k,v),i|
        draw_materials_view_core(k,i)
      end
    end

    Window.draw(420,140,Image[:right]) if page == 0
    Window.draw(420,140,Image[:left]) if page == 1
  end

  def draw_materials_view_core(k,i)
    page = @game.page
    return if (page+1)*16 <= i || page*16 > i
    Window.draw(10+200*(((i%16)/8).floor), 20+40*(i%8), @iconback_s)
    Window.draw_scale(-6+200*(((i%16)/8).floor), 4+40*(i%8), Image[k], 0.5, 0.5)
    Window.draw_font(45+200*(((i%16)/8).floor), 28+40*(i%8), "x "+@material.have_materials[k].to_s, Font20)
    Window.draw_font(90+200*(((i%16)/8).floor), 28+40*(i%8), atom_j(@material.know_materials[k]), Font20)
  end

  def draw_reagents_view
    page = @game.page
    10.times do |i|
      next if @game.experiment.reagents.size < i+1
      reagent = @game.experiment.reagents[page*10+i]
      Window.draw_font(20, 20+40*i, "試薬"+(page*10+i+1).to_s, Font20, mouseover_color(@controller.pos_reagents_view == i)) 
      2.times do |j|
        Window.draw(100+170*j, 15+40*i, @iconback_s)
        Window.draw_scale(84+170*j, -1+40*i, reagent[j].class == Symbol ? Image[reagent[j]] : Image[:potion], 0.5, 0.5)
        Window.draw_font(140+170*j, 20+40*i, reagent[j].class == Symbol ? reagent[j] : "試薬"+(reagent[j]+1).to_s, Font16) 
      end
    end
  end

  def draw_set_materials
    material = @game.experiment.material
    2.times do |i|
      Window.draw(EXPERIMENT[i][0], EXPERIMENT[i][1], @iconback)
      if material[i].class == Symbol
        Window.draw_font(EXPERIMENT[i][0], EXPERIMENT[i][1]-25, material[i].to_s, Font20)
        Window.draw(EXPERIMENT[i][0], EXPERIMENT[i][1], Image[material[i]]) 
      elsif material[i].class == Number
        Window.draw_font(EXPERIMENT[i][0], EXPERIMENT[i][1]-25, "試薬"+(material[i]+1).to_s, Font20)
        Window.draw(EXPERIMENT[i][0], EXPERIMENT[i][1], Image[:potion]) 
      end
      pos = @controller.pos_kind_of_material
      Window.draw_font(113+150*i, 155, "素材", Font20, mouseover_color(pos[0] == i && pos[1] == 0))
      Window.draw_font(113+150*i, 180, "試薬", Font20, mouseover_color(pos[0] == i && pos[1] == 1))   
    end
    Window.draw_font(170, 222, "反応させる", Font20, mouseover_color(@controller.pos_start_experiment?))
  end

  def draw_experiment_result
    note = @game.experiment.note
    draw_note(note.size-1)
    Window.draw_font(30, 300, note.to_s, Font20)
    Window.draw_font(30, 250, "続けて実験を行う", Font20, mouseover_color(@controller.pos_one_more_experiment?))
  end

  def draw_go_out
    Window.draw(10,30,@placeback)
    Window.draw(170,30,@placeback)
    Window.draw_font(15,36,"城下町(2時間)",Font20)
    Window.draw_font(180,36,"素材集め",Font20)
      
    PLACES.each_with_index do |(k,v),i|
      next if k == :home
      if i < 5 #城下町
        Window.draw_font(20, 65+i*25, v[0], Font20, mouseover_color(@controller.pos_go_out == i))
      else #素材集め
        Window.draw_font(180, 65+(i-5)*25, v[0], Font20, mouseover_color(@controller.pos_go_out == i))
      end
    end
  end

  def draw_place
    Window.draw_font(20, 60, "draw_place_main", Font20)
  end

  def draw_note_view
    page = @game.page
    draw_note(page)
    Window.draw(60,260,Image[:left]) if page != 0
    Window.draw(150,260,Image[:right]) if page != @game.experiment.note.size-1
  end

  def draw_note(no)
    note = @game.experiment.note[no]
    Window.draw_font(30, 50, "実験#"+(no+1).to_s, Font20) 
    Window.draw_font(116, 90, "+", Font50) 
    Window.draw_font(245, 94, "→", Font50) if note[3][1] != 0
    Window.draw_font(140, 50, note.to_s, Font20) # テスト用表示
    3.times do |i|
      Window.draw(30+140*i,90,@iconback)
      if note[i].class == Symbol
        Window.draw(30+140*i,90,Image[note[i]])
        Window.draw_font(30+140*i, 160, note[i], Font20)
      elsif note[i].class == Number && note[i] != -1
        Window.draw(30+140*i,90,Image[:potion])
        Window.draw_font(30+140*i, 160, "試薬"+(note[i]+1).to_s, Font20)
      end
    end
    Window.draw_font(30, 200, "魔力変化 " + (note[3][0] ? "有" : "無") + "　　魔力量 " + note[3][1].to_s, Font20) 
  end

  def draw_main_menu
    MAIN_MENU_TEXT.each_with_index do |menu,i|
      Window.draw_font(640 - MAIN_MENU_WIDTH + 30, MENU_EACH_HEIGHT*i+5, menu, Font20, mouseover_color(@controller.pos_main_menu == i)) 
    end
  end

  def draw_places_menu
    @game.places_for_menu.each_with_index do |e,i|
      Window.draw_font(640 - MAIN_MENU_WIDTH + 30, MENU_EACH_HEIGHT*i+5, e[1], Font20, mouseover_color(@controller.pos_main_menu == i))
    end
  end

  def draw_rest
    2.times do |i|
      Window.draw_font(30, 30+40*i, ((i+1)*4).to_s+"時間寝る", Font20, mouseover_color(@controller.pos_rest == i))
    end
  end

  def draw_schedule
    s = @game.schedule
    Window.draw_font(480, SCHEDULE_HEIGHT+10, "#{s.season} #{s.day+1}日(#{s.weekday}) #{s.hour}時", Font20, {color: WHITE})
    Window.draw(640-MAIN_MENU_WIDTH, SCHEDULE_HEIGHT, @clock)
  end

  def draw_health
    Window.draw_font(475, 215, "体力: "+@game.health.to_s+" / 30", Font20)
  end

  def draw_message(str_array)
    str_array.each_with_index do |text, i|
      Window.draw_font(10, 480-MESSAGE_BOX_HEIGHT+i*22, text, Font20) 
    end
  end

  def draw_xy
    Window.draw_font(0,0,Input.mouse_pos_x.to_s+" "+Input.mouse_pos_y.to_s,Font16)
  end

  def draw_debug
  
  end

  def mouseover_color(bool, color=WHITE)
    return {color: GREEN} if bool
    return {color: color}
  end

  def atom_j(atoms)
    return "???" unless atoms
    atom = atoms.to_s.split("")
    str = []
    atom.each do |a|
      case(a)
      when "f"
        str << "火"
      when "e"
        str << "土"
      when "w"
        str << "風"
      when "a"
        str << "水"
      when "l"
        str << "陽"
      when "d"
        str << "陰"
      end
    end  
    return str[0]+"-"+str[1]
  end

end