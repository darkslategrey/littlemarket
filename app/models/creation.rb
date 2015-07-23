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
    logger.debug "params #{params}"
    begin
      Creation.upsertFromLM params, force
    rescue Exception => e
      raise e
    end
    
  end

  def self.upsertFromLM params, force
    creation = Creation.find_by_lm_id(params["lm_id"])
    if creation.nil?
      creation = Creation.create! params      
    elsif force
      creation.update! params
    else
      raise ActiveRecord::ActiveRecordError.new("creation allready exists: #{params['lm_id']}")
    end
    creation
  end
  
end
