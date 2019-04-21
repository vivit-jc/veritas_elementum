class Material

attr_reader :material_atoms, :know_materials, :have_materials

  def initialize
    atoms = ATOMS.clone
    @material_atoms = []
    @material_atoms += atoms + atoms
    6.times do
      @material_atoms.push atoms.sample
    end
    @material_atoms.shuffle!

    @know_materials = Array.new(30).map{|e|0}
    @have_materials = Array.new(30).map{|e|0}
  end

end