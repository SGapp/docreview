# encoding: utf-8

class BylawsExtractor
  attr_reader :contract, :content, :articles

  def initialize(contract)
    @contract = contract
    @content = contract.content
    @articles = contract.articles
    @articles_objects = []
    contract.articles.map do |article|
      @articles_objects << Article.new(article)
    end
  end

  def name
    @content[/(^.*?(?=société|Société))/m].strip.gsub(/\s{2}+/, "")
  end

  def designation
    company_designation = ""
    @articles_objects.each do |article|
      company_designation = article.full_article if article.full_article[/(dénomination sociale|DENOMINATION)/]
    end
    company_designation
  end

  def form
    @content[/(SAS|SARL|SA|SCI|EURL|SASU|S\.A\.S|S\.A\.R\.L|S\.A|S\.C\.I|E\.U\.R\.L|S\.A\.S\.U)/]
  end

  def duration
    @articles_objects.each do |article|
      return article.full_article if article.full_article =~ /(durée|duree)/i && article.full_article =~ /(est fixée)/i && article.full_article =~ /(immatriculation)/i
    end
  end

  def head_office
    @articles_objects.each do |article|
      return article.full_article if article.full_article[/siège social est/]
    end
  end

  def purpose
    @articles_objects.each do |article|
      return article.full_article if article.full_article =~ /objet social est/ || article.full_article =~ /a pour objet/
    end
  end

  def share_capital
    @articles_objects.each do |article|
      return article.full_article if article.full_article[/(capital social|capital initial)/] && article.full_article[/libéré/] && !article.full_article[/apport/]
    end
  end

  def contribution
    @articles_objects.each do |article|
      return article.full_article if article.title =~ /apports/i
    end
  end

  def directors
    company_directors = []
    @articles_objects.each do |article|
      if article.title =~ /président directeur général/i
        company_directors << "Président Directeur Général"
      elsif article.title =~ /président/i
        company_directors << "Président"
      elsif article.title =~ /gérant/i
        company_directors << "Gérant"
      elsif article.title =~ /directoire/i
        company_directors << "Directoire"
      end
      company_directors << "Directeur Général Délégué" if article.title =~ /directeur général délégué/i
      company_directors << "Directeur Général" if article.title =~ /directeur général/i
    end
    company_directors
  end

  def powers_limitations(company_directors)
    power_chunk = {}
    company_directors.each do |director|
      @articles_objects.each do |article|
        if article.content =~ /(?<=\.)([^\.]*(?:#{director} ne peut|#{director} ne pourra|#{director} ne pourront|autorisation préalable|sans l'accord)[^\.]*)(?=\.)/i
          power_chunk[article.title] = article.content[/(?<=\.)([^\.]*(?:#{director} ne peut|#{director} ne pourra|#{director} ne pourront|autorisation préalable|sans l'accord)[^\.]*)(?=\.)/i]
        end
      end
    end
    power_chunk.to_a
  end

  def corporate_bodies
    corporate_bodies = []
    @articles_objects.each do |article|
      if article.title =~ /comité/i
        corporate_bodies << article.title
        break
      end
      if article.title =~ /commission/i
        corporate_bodies << article.title
        break
      end
      if article.title =~ /direction/i
        corporate_bodies << article.title
        break
      end
    end
    if corporate_bodies == []
      return corporate_bodies
    else
      return ["Les statuts ne comportent d'autres organes sociaux."]
    end
  end

  def social_decisions
    social_decisions = []
    @articles_objects.each do |article|
      social_decisions << article.full_article if article.title =~ /(assemblée générale|décisions collectives|décisions des associés|décisions d'associés)/i
    end
    social_decisions
  end

  def preemption
    @articles_objects.each do |article|
      if article.title =~ /préemption/i && article.full_article =~ /droit de préemption/i
        return article.full_article
      else
        return "Les statuts ne comportent pas de clause de préemption."
      end
    end
  end

  def approval
    @articles_objects.each do |article|
      if article.title =~ /agrément/i && article.full_article =~ /demande d'agrément/i
        return article.full_article
      else
        return "Les statuts ne comportent pas de clause d'agrément."
      end
    end
  end

end

  # def approval
  #   @articles_objects.each do |article|
  #     return article.full_article if article.title =~ /agrément/i && article.full_article =~ /demande d'agrément/i
  #   end
  # end

