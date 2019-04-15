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
      @material[@setting_material] = pos
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
    if(result[1] == 0)
      reagent_no = -1
    else
      @reagents.push [@material[0], @material[1]]
      reagent_no = @reagents.size-1
    end
    @note.push [@material[0], @material[1], reagent_no, result]
    @material = [nil,nil]

  end

  def reaction(mat) # in:[mat,mat]
    p "reaction"
    atoms = [nil,nil]
    2.times do |i|
      if !mat[i] 
        next
      elsif mat[i].class == Symbol
      	atoms[i] = @material_atoms[MATERIALS.find_index{|m|m == mat[i]}]
      elsif mat[i].class == Number
        atoms[i] = reaction(@reagents[mat[i]])[2]
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

    big_count = 0
    reacted_atoms = []
    splited_atoms = atoms.map{|a|a.to_s.split("")}.flatten.sort.inject{|sum, a|sum+a}
    ["aa","dd","ll","ee","ww","ff"].each do |big|
      if splited_atoms.include?(big)
        reacted_atoms.push big
        splited_atoms = splited_atoms.sub(big,"")
        big_count += 1
      end
    end
    return [true, 0, nil] if big_count >= 2
    reacted_atoms += splited_atoms.split("")
  	[[:f,:a],[:w,:e],[:l,:d]].each do |pair|
      reacted_atoms.delete_if{|a|a == pair[0] || a == pair[1]} if splited_atoms.include?(pair[0]) && splited_atoms.include?(pair[1])
    end
    atom_result = nil
    atom_result = reacted_atoms.inject{|atom, e|atom + e.to_s} if reacted_atoms
    return [true, atom_result.to_s.size/2, atom_result]
  end

  def mes_experiment(mes)
    if(!@note.last[3][0])
      mes[0] = "試薬"+(@note.last[2]+1).to_s+"を2つ得た"
      mes[1] = "2つの素材は同一成分であると考えられる"
    elsif(@note.last[3][1] == 0)
      mes[0] = "魔力反応が消失した"
    else
      mes[0] = "試薬"+(@note.last[2]+1).to_s+"を得た"
    end
  end

end