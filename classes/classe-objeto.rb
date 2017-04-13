class ManipulaObjetos
  attr_accessor :s3, :client
  def initialize(s3, client)
    @s3 = s3
    @client = client
  end
  # Valida Nome do objeto
  #
  def verifica_objeto(este_objeto, op)
    if !este_bucket.exists? && op == 'se tem'
      puts "\nO bucket '#{este_objeto.name}' nao existe!"
      return false
    end
    if este_objeto.exists? && op == 'se nao tem'
      puts "\nO objeto '#{este_objeto.name}' ja existe! Escolha outro nome!"
      return false
    else
      return true
    end
  end
  # Lista objetos
  #
  def lista_objetos(deste_bucket)
    if deste_bucket.exists?
      puts "\n                 - - LISTANDO OBJETOS DO BUCKET: '#{deste_bucket.name}' - - "
      deste_bucket.objects.each do |objectsummary|
        puts "\nObjeto nome:  #{objectsummary.key}
        Modificado em: #{objectsummary.last_modified}
        URL => #{objectsummary.public_url}"
      end
      # resp = client.list_objects_v2({
      #   bucket: scan,
      # })
    else
      puts "\nO bucket '#{deste_bucket.name}' nao existe!"
    end
  end
  # Sobe arquivo
  #
  def sobe_arquivo(the_bucket, scan2)
    @arquivo = File.basename scan2
    # @objeto = the_bucket.object(@arquivo)
    @objeto = the_bucket.object(scan2)
    @caminho = Dir.pwd.concat("/#{scan2}")
    puts @caminho
    if @objeto.upload_file(@caminho)
      puts "\nArquivo '%s' subido com sucesso!" % scan2
    else
      puts "\nNao foi possivel subir o arquivo ao bucket '#{the_bucket.name}'!"
    end
  end
  # Baixa Arquivo
  #
  def baixar_arquivo(bucket_selecionado, scan)
    if bucket_selecionado.object(scan).get(response_target: Dir.pwd.concat("/#{scan}"))
      puts "\nO arquivo #{scan} foi baixado com sucesso!
      Disponível em #{Dir.pwd}"
    else
      puts "\nNão foi possível encontrar e baixar o arquivo #{scan}"
    end
  end
end
