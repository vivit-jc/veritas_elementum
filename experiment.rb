class Experiment

  attr_accessor :setting_material
  attr_reader :material, :reagents, :note

  def initialize
    @setting_material = 0
    @material = [nil,nil]
    @reagents = []
    @note = []
  end

  def set_veritas(atoms)
  	@material_atoms = atoms
  end

  def set_material(pos, sym)
    if sym == :m
      @material[@setting_material] = MATERIALS[pos]
    elsif sym == :r 
    end
  end

  def verify
  	if(!@material[0] or !@material[1])
  	  return "材料は２つ選ぶ必要がある・・・"
    elsif(@material[0] == @material[1])
      return "同じ材料同士を実験するのは無意味だ・・・"
    end
    return 0
  end

  def make_reagent
  	p "make_reagent"
  	reagent_no = nil
    result = reaction(@material)

    reagent_no = @reagents.find_index {|reagent| 
    	reagent == [@material[0], @material[1]] || reagent == [@material[1], @material[0]] }
    if(reagent_no)
      reagent_no += 1  
    elsif(result[1] == 0)
      reagent_no = -1
    else
      @reagents.push [@material[0], @material[1]]
      reagent_no = @reagents.size
    end
    @note.push [@material[0], @material[1], reagent_no, result]
    @material = [nil,nil]

  end

  def reaction(mat)
    p "reaction", mat
    atoms = [nil,nil]
    result = [nil,nil,nil]
    2.times do |i|
      if !mat[i] 
        next
      elsif mat[i].class == Symbol
      	atoms[i] = @material_atoms[MATERIALS.find_index{|m|m == mat[i]}]
      elsif mat[i].class == Number
      else
      	raise "引数の値がおかしい"
      end
    end
    return calc_reaction(atoms)
  end

  def calc_reaction(atoms)
    #魔力反応、魔力量、出来た元素を返す
    p "calc_reaction"
    return [false, 2, atoms[0]] if(atoms[0] == atoms[1])

  	splited_atoms = atoms.map{|a|a.to_s.split("")}.flatten.sort.map{|a|a.intern}
    reacted_atoms = splited_atoms.clone
  	[[:f,:a],[:w,:e],[:l,:d]].each do |pair|
      reacted_atoms.delete_if{|a|a == pair[0] || a == pair[1]} if splited_atoms.include?(pair[0]) && splited_atoms.include?(pair[1])
    end
    return [true, reacted_atoms.size/2, reacted_atoms]
  end

  def mes_experiment(mes)
    if(!@note.last[3][0])
      mes[0] = "試薬"+@note.last[2].to_s+"を2つ得た"
      mes[1] = "2つの素材は同一成分であると考えられる"
    elsif(@note.last[3][1] == 0)
      mes[0] = "魔力反応が消失した"
      mes[1] = "2つの素材の成分は相反する成分と考えられる"
    else
      mes[0] = "試薬"+@note.last[2].to_s+"を得た"
    end
  end

end