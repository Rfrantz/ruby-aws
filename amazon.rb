require "aws-sdk"
require "aws-sdk-core"
require "rubygems"
require "io/console"
require "pry"
load "classes/classes.rb"
load "classes/classe-objeto.rb"
listando = "
                                          - LISTANDO BUCKETS...
"
opcoes = "
                              ----------------------------------------------
                              -------    Utilize os comando abaixo   -------
                              ----------------------------------------------
                              -------   delete  =>  DELETAR BUCKET   -------
                              -------   listar  =>  LISTA BUCKETS    -------
                              -------   criar   =>  CRIA BUCKET      -------
                              -------   upload  =>  SOBE OBJETOS     -------
                              -------   url     =>  BUCKET URL       -------
                              -------   acesso  =>  ACESSOS          -------
                              -------   baixar  =>  DOWNLOAD         -------
                              -------   sair    =>  FECHA APP        -------
"

apresentacao = <<DOC




                             - BEM VINDO A INTEGRAÇÃO AWS COM RUBY -

                ***********************************************************************
                *                                                                     *
                *  ======= Este é um teste de interação com a AWS com o Ruby  ======  * 
                *  ================   que permite os seguintes:   ==================  *
                *                                                                     *
                *  _________________________________________________________________  *
                *                                                                     *
                *                     | CRIAR BUCKET                                  *
                *                     | URL DO BUCKET                                 *
                *                     | DELETAR BUCKET                                *
                *                     | UPLOAD DE ARQUIVO                             *
                *                     | DOWNLOAD DE OBJETO                            *
                *                     | LISTAR BUCKETS/OBJETOS                        *
                *                                                                     *
                ***********************************************************************
                | Criado em Ruby [por] Raphael Gallotti Frantz


DOC

termino_periodo = "
                  ==================================================================="


operacao = "listar"
region = "us-west-2"
# region = "us-east-1"

Aws.use_bundled_cert!
Aws.config.update(credentials: Aws::Credentials.new("AKIAJP7SCMDFGEUU6FFQ", "wWlyFiFCmjR7wq3TaE2iFX87ba2mdalBqiZA23Ov"))
client = Aws::S3::Client.new(region: region)
s3 = Aws::S3::Resource.new(client: client)

manipula_buckets = ManipulaBuckets.new(s3)
manipula_objetos = ManipulaObjetos.new(s3, client)

puts apresentacao
while operacao != "sair"
  puts opcoes
  puts "\nO que deseja fazer?"
  STDOUT.flush
  operacao = gets.chomp
  case operacao
  when "criar"
    puts "\nDigite o nome para criar um novo bucket:"
    STDOUT.flush
    scan = gets.chomp
    manipula_buckets.criaBucket_Nome(scan)
  # UPLOAD de arquivo unico
  #
  when "upload"
    # Escolhendo o arquivo a ser enviado
    puts "\nDigite o nome do bucket para alocar o objeto:"
    STDOUT.flush
    scan10 = gets.chomp
    b = manipula_buckets.seta_nome_bucket(scan10)
    if manipula_buckets.verifica_bucket(b, 'se tem')
      puts "\nDigite o nome do arquivo a ser enviado"
      STDOUT.flush
      scan2 = gets.chomp
      manipula_objetos.sobe_arquivo(b, scan2)
    else
      puts "\nDeseja criar o bucket antes de fazer upload [Y/N]?"
      STDOUT.flush
      scan = gets.chomp
      if scan == 'y' || scan == 'Y'
        novo_bucket_2 = manipula_buckets.criaBucket_Nome(scan10)
        puts "\nBucket #{novo_bucket_2.name} criado com sucesso!"
        puts "\nDigite o nome do arquivo a ser enviado:"
        STDOUT.flush
        scan2 = gets.chomp
        manipula_objetos.sobe_arquivo(b, scan2)
      end
    end
  # Listagem de buckets e Objetos
  #
  when "listar"
    # Listando os buckets
    puts listando
    manipula_buckets.lista_buckets
    puts termino_periodo
    # Listando os objetos constantes no bucket
    #
    puts "\nDigite o nome do bucket para listar os objetos:"
    STDOUT.flush
    scan = gets.chomp
    @b = manipula_buckets.seta_nome_bucket(scan)
    manipula_objetos.lista_objetos(@b)
    puts termino_periodo
  # Modifica o acesso do bucket
  #
  when "acesso"
    manipula_buckets.lista_buckets
    puts "\nDigite o nome do bucket a ser modificado o acesso:"
    STDOUT.flush
    scan = gets.chomp
    @b = manipula_buckets.seta_nome_bucket(scan)
    if manipula_buckets.verifica_bucket(@b, "se tem")
      puts "\nDigite a nova privacidade do bucket:"
      STDOUT.flush
      scan2 = gets.chomp
      manipula_buckets.modifica_acesso_bucket(@b, scan2)
    end
  # Deleta buckets solicitados
  #
  when "delete"
    puts listando
    manipula_buckets.lista_buckets
    puts "\nDigite o nome do bucket à ser deletado:"
    scan = gets.chomp
    manipula_buckets.delete_bucket(scan)
  # Recupera a URL do bucket
  #
  when "url"
    puts "\nDigite o nome do bucket para o url:"
    STDOUT.flush
    scan = gets.chomp
    manipula_buckets.bucket_url(scan)
  # Download de arquivo
  #
  when "baixar"
    puts "\nDigite o nome do bucket para baixar arquivos:"
    STDOUT.flush
    scan = gets.chomp
    @b = manipula_buckets.seta_nome_bucket(scan)
    manipula_objetos.lista_objetos(@b)
    puts "\nDigite o nome do objeto para baixar:"
    STDOUT.flush
    scan2 = gets.chomp
    manipula_objetos.baixar_arquivo(@b, scan2)
  when "sair"
    puts "\nSaindo........."
    break
  else
    puts "\nAlgo deu errado, ou a operacao '#{operacao}' nao existe.
    Contate o desenvolvedor!"
    break
  end
end
