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
    creation = Creation.find_by_lm_id(params[:lm_id])
    if creation.nil?
      creation = Creation.create! params      
    elsif force
      creation.update! params
    # else
    #   raise ActiveRecord::ActiveRecordError.new("creation allready exists: #{params['lm_id']}")
    end
    creation
  end

  def to_new_form
    categ, form_ssncateg, form_ncateg3_ss    = categs.split ','    
    delai, profile                           = deliveries.split ','
    prix, sell_prix_promo, qte               = prices.split ','
    pseudo_membre_reservation, mise_en_ligne = options.split ','

    form =     { 'categ' => categ, 'form_ssncateg' => form_ssncateg, 'form_ncateg3_ss' => form_ncateg3_ss }

    form.merge!({ 'delai'        => delai, 'profile' => profile })
    form.merge!({ 'prix'         => prix, 'sell_prix_promo' => sell_prix_promo, 'qte' => qte })
    form.merge!({ 'motclef[]'    => tags.split(',') })    
    form.merge!({ 'colors[]'     => Color.find_by_names(colors) })
    form.merge!({ 'destinataire' => dest })
    form.merge!({ 'matieres[]'   => materials.split(',') })
    form.merge!({ 'occasion'     => events })
    form.merge!({ 'styles'       => styles })
    form.merge!({ 'subtitle'     => subtitle })
    form.merge!({ 'texte'        => desc })
    form.merge!({ 'titre'        => title })
    form.merge!({ 'pseudo_membre_reservation' => pseudo_membre_reservation, 'mise_en_ligne' => mise_en_ligne }) 
  end

end
