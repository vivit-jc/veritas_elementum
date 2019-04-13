require 'native' 
#alias_method :new_name, :old_name

class Controller
  attr_reader :x,:y,:mx,:my

  def initialize(game)
    @game = game
  end

  def input
    @mx = Input.mouse_x
    @my = Input.mouse_y
    if Input.mouse_push?( M_LBUTTON )
      case @game.status
      when :title
        @game.start if(pos_title_menu == 0)
        @game.stats if(pos_title_menu == 1)
        @game.all_clear if(pos_title_menu == 2)
      when :game
        click_on_game
      when :stats
        @game.go_title if(pos_return)
      when :end
        @game.next if(pos_return)
      end
    end
    if(Input.key_push?(K_SPACE))
      case @game.status
      when :game
        
      end
    end
  end

  def click_on_game
    if pos_main_menu != -1
      @game.click_menu(pos_main_menu)
    else
      case(@game.mainview_status)
      when :materials_view
        if pos_materials_view_page_select? 
          @game.click_material_page
        elsif pos_materials_view != -1
          @game.click_material(pos_materials_view, :m)
        end
      when :set_materials
        @game.set_material(pos_set_materials) if pos_set_materials != -1
        @game.start_experiment if pos_start_experiment?
      when :experiment_result
        @game.click_menu(0) if pos_one_more_experiment?
      end
    end
  end

  def pos_title_menu
    3.times do |i|
      #return i if(mcheck(MENU_X, MENU_Y[i], MENU_X+Font32.get_width(MENU_TEXT[i]), MENU_Y[i]+32))
      return i if(mcheck(TITLE_MENU_X, TITLE_MENU_Y[i], TITLE_MENU_X+get_width(TITLE_MENU_TEXT[i]), TITLE_MENU_Y[i]+32))
    end
    return -1
  end

  def pos_main_menu
    MAIN_MENU_TEXT.each_with_index do |menu, i|
      #return i if(mcheck(MENU_X, MENU_Y[i], MENU_X+Font32.get_width(MENU_TEXT[i]), MENU_Y[i]+32))
      return i if(mcheck(640-MAIN_MENU_WIDTH, MENU_EACH_HEIGHT*i, 640, MENU_EACH_HEIGHT*(i+1)))
    end
    return -1
  end

  def pos_materials_view_page_select?
    return true if mcheck(420,140,420+64,140+64)
    return false
  end

  def pos_materials_view
    page = @game.page
    3.times do |i|
      5.times do |j|
        return j+i*5+page*15 if mcheck(20+80*j,20+110*i,20+80*j+64,20+110*i+64)
      end
    end
    return -1
  end

  def pos_set_materials
    2.times do |i|
      return i if mcheck(EXPERIMENT[i][0],EXPERIMENT[i][1],EXPERIMENT[i][0]+64,EXPERIMENT[i][1]+64)
    end
    return -1
  end

  def pos_start_experiment?
    mcheck(170,222,170+get_width("実験する"),242)
  end

  def pos_one_more_experiment?
    mcheck(30,250,30+get_width("続けて実験を行う"),270)
  end

  def get_width(str)
    canvas = Native(`document.getElementById('dxopal-canvas')`)
    width = canvas.getContext('2d').measureText(str).width
    return width
  end

  def mcheck(x1,y1,x2,y2)
    x1 < @mx && x2 > @mx && y1 < @my && y2 > @my    
  end
end