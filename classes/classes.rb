class ManipulaBuckets
  attr_accessor :s3
  def initialize(s3)
    @s3 = s3
  end
  # Seta bucket pelo nome
  #
  def seta_nome_bucket(scan)
    @bucket_com_nome = s3.bucket(scan)
    return @bucket_com_nome
  end
  # Valida Nome do bucket
  #
  def verifica_bucket(este_bucket, op)
    if !(este_bucket.exists? && op == 'se tem')
      puts "\nO bucket '#{este_bucket.name}' nao existe!"
      return false
    end
    if este_bucket.exists? && op == 'se nao tem'
      puts "\nO bucket '#{este_bucket.name}' ja existe! Escolha outro nome!"
      return false
    else
      return true
    end
  end

  # Funcao de Criacao de buckets
  # Recebe nome do bucket como arg.
  #
  def criaBucket_Nome(scan)
    # Criando o Bucket com o nome desejado
    @novo_bucket = seta_nome_bucket(scan)
    if verifica_bucket(@novo_bucket, 'se nao tem')
      @novo_bucket.create
      puts "\nBucket '%s' criado com sucesso!" % scan
    end
  end

  # Listagem dos buckets constantes no s3
  #
  def lista_buckets
    s3.buckets.each do |bucket|
      puts "Bucket Nome: #{bucket.name}"
      # Para URL - URL: #{bucket.url}
    end
  end

  # Mehtodo para delecao de bucket
  #
  def delete_bucket(scan)
    @del_bucket = seta_nome_bucket(scan)
    if verifica_bucket(@del_bucket, 'se tem')
      @del_bucket.delete!
      puts "\nBucket '%s' deletado com sucesso!" % scan
    else
      return nil
    end
  end

  # Mehtodo para obter o site do bucket
  #
  def bucket_url(scan)
    @url_bucket = seta_nome_bucket(scan)
    unless !verifica_bucket(@url_bucket, 'se tem')
      @uri = @url_bucket.url
      puts @uri.to_s
    end
  end

  def modifica_acesso_bucket(the_bucket, scan2)
    case scan2
    when 'publico'
      @x = 'public-read-write'
    when 'particular'
      @x = 'private'
    when 'leitura'
      @x = 'public-read'
    else
      p 'Digitou a permissão errada. #{the_bucket.name} => #{the_bucket.acl}'
    end
    @bucket_acl = the_bucket.acl(acl @x)
    p @bucket_acl
  end
end
