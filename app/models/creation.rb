class Creation < ActiveRecord::Base


  def self.createFromLM creationLM, force: false
    params = {}
    creationLM.each_pair do |k, v|

      case v
      when Hash
        params[k] = v.values.join ','
      when Array
        params[k] = v.join ','
      else
        params[k] = v
      end
      
    end

    begin
      Creation.upsertFromLM params, force
    rescue Exception => e
      raise e
    end
    
  end

  def self.upsertFromLM params, force
    creation = Creation.find_by_lmid(params[:lmid])
    if creation.nil?
      creation = Creation.create! params      
    elsif force
      creation.update! params
    # else
    #   raise ActiveRecord::ActiveRecordError.new("creation allready exists: #{params['lmid']}")
    end
    creation
  end

  def to_new_form
    categ, form_ssncateg, form_ncateg3_ss    = categs.split ','    
    delai, profile                           = deliveries.split ','
    prix, sell_prix_promo, qte               = prices.split ','
    pseudo_membre_reservation, mise_en_ligne = options.split ','

    form =     { 'categ' => categ, 'form_ssncateg' => form_ssncateg, 'form_ncateg3_ss' => form_ncateg3_ss }

    form.merge!({ 'delai'        => delai, 'profil' => profile })
    form.merge!({ 'prix'         => prix, 'sell_prix_promo' => sell_prix_promo, 'qte' => qte })
    form.merge!({ 'destinataire' => dest })
    form.merge!({ 'occasion'     => events })
    form.merge!({ 'styles'       => styles })
    form.merge!({ 'subtitle'     => subtitle })
    form.merge!({ 'texte'        => desc })
    form.merge!({ 'titre'        => title })
    form.merge!({ 'pseudo_membre_reservation' => pseudo_membre_reservation, 'mise_en_ligne' => mise_en_ligne })

    tags_str      = tags.split(',').map             { |t| "motclef[]=#{t.strip}" }.join '&'
    colors_str    = Color.find_by_names(colors).map { |c| "colors[]=#{c}" }.join '&'
    materials_str = materials.split(',').map do |m|
      "matieres[]=#{Material.find_by_value(m).name}"
    end.join '&'
    # materials_str = materials.split(',').map        { |m| "matieres[]=#{m.strip}" }.join '&'
    "#{form.to_param}&#{tags_str}&#{colors_str}&#{materials_str}"
    
  end

end
