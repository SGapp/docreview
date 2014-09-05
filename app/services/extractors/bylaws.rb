# encoding: utf-8

module Extractors

  class Bylaws
    attr_reader :contract, :content, :articles

    def initialize(contract)
      @contract = contract
      @content = contract.content
      @articles = contract.articles
    end

    def name
      if content[/(statuts constitutifs)/i]
        return content[/(?<=DE LA SOCIETE|STATUTS CONSTITUTIFS DE LA SOCIETE).*?(?=société)/im].strip.gsub(/\s{2}+/, "")
      else
        return content[/(^.*?(?=société|au capital))/im].strip.gsub(/\s{2}+/, "")
      end
    end

    def designation
      @articles.each do |article|
        return article.full_article if article.full_article[/(dénomination sociale|DENOMINATION)/]
      end
    end

    def form
      @content[/(SAS|SARL|SA|SCI|EURL|SASU|S\.A\.S|S\.A\.R\.L|S\.A|S\.C\.I|E\.U\.R\.L|S\.A\.S\.U)/]
    end

    def duration
      @articles.each do |article|
        return article.full_article if article.full_article =~ /(la durée de la société est fixée|a une durée de)/i
      end
    end

    def head_office
      @articles.each do |article|
        return article.full_article if article.full_article =~ /(siège social est|de la société est fixé)/i
      end
    end

    def purpose
      @articles.each do |article|
        return article.full_article if article.full_article =~ /objet social est/ || article.full_article =~ /a pour objet/
      end
    end

    def share_capital
      @articles.each do |article|
        return article.full_article if article.full_article[/(capital social|capital initial)/] && article.full_article[/divisé/] && !article.full_article[/apport/]
      end
    end

    def contribution
      @articles.each do |article|
        return article.full_article if article.title =~ /(apports|formation du capital|répartition du capital)/i
      end
    end

    def directors
      @company_directors = []
      @articles.each do |article|
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
      @company_directors.join(', ')
    end

    def powers_limitations
      power_chunk = {}
      @company_directors.each do |director|
        @articles.each do |article|
          if article.content =~ /(?<=\.)([^\.]*(?:#{director} ?(de la société) ne peut|#{director} ne pourra|#{director} ?(de la société) ne pourront)[^\.]*)(?=\.)/i
            power_chunk[article.title] = article.content[/(?<=\.)([^\.]*(?:#{director} ?(de la société) ne peut|#{director} ?(de la société) ne pourra|#{director} ?(de la société) ne pourront)[^\.]*)(?=\.)/i]
          end
        end
      end
      if power_chunk == {}
        return "Les statuts ne comportent pas de limitation de pouvoirs."
      else
        return power_chunk.to_a.join("\n")
      end
    end

    def corporate_bodies
      corporate_bodies = []
      @articles.each do |article|
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
        return "Les statuts ne comportent d'autres organes sociaux."
      else
        return corporate_bodies.join(" ,")
      end
    end

    def social_decisions
      social_decisions = []
      @articles.each do |article|
        social_decisions << article.full_article if article.title =~ /(assemblée générale|décisions collectives|décisions des associés|décisions d'associés)/i
      end
      social_decisions.join("\n")
    end

    def preemption
      preemption = ""
      @articles.each do |article|
        if article.title =~ /préemption/i && article.content =~ /droit de préemption/i
          preemption = article.full_article
        end
      end
      preemption = "Les statuts ne comportent pas de clause de préemption." if preemption == ""
      return preemption
    end

    def approval
      approval = ""
      @articles.each do |article|
        if article.title =~ /agrément/i && article.content =~ /demande d'agrément/i
          approval = article.full_article
        end
      end
      approval = "Les statuts ne comportent pas de clause d'agrément." if approval == ""
      return approval
    end

    def inalienability
      inalienability = ""
      @articles.each do |article|
        if article.title =~ /inaliénabilité/i
          inalienability = article.full_article
        end
      end
      inalienability = "Les statuts ne comportent pas de clause d'inaliénabilité des titres." if inalienability == ""
      return inalienability
    end

    def change_of_control
      control = ""
      @articles.each do |article|
        if article.full_article =~ /changement de contrôle/i
          control = article.full_article
        end
      end
      control = "Les statuts ne comportent pas de clause de changement de contrôle d'une société associée." if control == ""
      return control
    end

    def tag_along
      tag_along = ""
      @articles.each do |article|
        if article.full_article =~ /sortie conjointe/i
          tag_along = article.full_article
        end
      end
      tag_along = "Les statuts ne comportent pas de clause de sortie conjointe." if tag_along == ""
      return tag_along
    end

    def drag_along
      drag_along = ""
      @articles.each do |article|
        if article.full_article =~ /(sortie conjointe|sortie forcée)/i
          drag_along = article.full_article
        end
      end
      drag_along = "Les statuts ne comportent pas de clause de sortie forcée." if drag_along == ""
      return drag_along
    end

    def exclusion
      exclusion = ""
      @articles.each do |article|
        if article.title =~ /exclusion/i
          exclusion = article.full_article
        end
      end
      exclusion = "Les statuts ne comportent pas de clause d'exclusion." if exclusion == ""
      return exclusion
    end

    def financial_year
      @articles.each do |article|
        return article.full_article if article.title =~ /exercice social/i
      end
    end

  end


end