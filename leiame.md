share-site-creators
==============

Este add-on permite você restringir no Alfresco Share a criação de site para um grupo específico de usuários. Usuários que não estiverem no grupo, não poderão criar site nos links abaixo:

* Menu dropdown do cabeçalho dos sites
* No dashlet de "Meus sites"
* No Dashlet "bem-vindo"

No mais, para usuáros que não estiverem no grupo, o texto "boas-vindas" do dashlet muda para explicar o que é um site de compartilhamento, mas não implica que eles têm a capacidade de criar um. Um bom aprimoramento pode ser um link que lança um fluxo de trabalho para solicitar um novo site. (Pull solicitações bem-vindos!)

Por padrão, deve existir um grupo com um ID de "GROUP_SITE_CREATORS". o nome de exibição pode ser qualquer coisa. Quando você criar um grupo, não precisa especificar "GROUP_", o Alfresco fará isso por você.

Esse add-on também altera as permissões de baixo nível para que mesmo se alguém descobrir como criar um site sem a interface do usuário, a camada do repositório não permitirá que elas façam isso a menos que estejam no grupo.

Maven
-----
Adicionar as dependências e sobreposições para os arquivos POM de seu projeto WAR.

Para a camada de repositório, em um projeto criado com o arquétipo all-in-one, altere o arquivo repo/pom.xml:


    <dependencies>
      ...
      <dependency>
          <groupId>com.metaversant</groupId>
          <artifactId>share-site-creators-repo</artifactId>
          <version>0.0.5</version>
          <type>amp</type>
      </dependency>
      ...
    </dependencies>

    <overlays>
      ...
      <overlay>
          <groupId>com.metaversant</groupId>
          <artifactId>share-site-creators-repo</artifactId>
          <type>amp</type>
      </overlay>
      ...
    </overlays>

Para a camada Share, no projeto criado com arquitipo  all-in-one, altere o arquivo share/pom.xml:

    <dependencies>
      ...
      <dependency>
          <groupId>com.metaversant</groupId>
          <artifactId>share-site-creators-share</artifactId>
          <version>0.0.5</version>
          <type>amp</type>
      </dependency>
      ...
    </dependencies>

    <overlays>
      ...
      <overlay>
          <groupId>com.metaversant</groupId>
          <artifactId>share-site-creators-share</artifactId>
          <type>amp</type>
      </overlay>
      ...
    </overlays>

Instalação Manual
-------------------
Existem dois AMPs associados com este add-on. Um é o "repo tier" AMP e o outro é o "Share tier" AMP.

Para cada um desses dois projetos, use `mvn install` para criar o AMP. Quando estiver usando a versão do Alfresco 5.1.f, você precisa especificar `-Ddependency.surf.version=6.3` no momento de executar os comandos do maven para a camada Share AMP.

### Instalando os AMPs

Você pode instalar os AMPs como você normalmente usaria o MMT. Por exemplo, para instalar no servidor, você copiaria `share-site-creators-repo.amp` para `$ALFRESCO_HOME/amps` e copiaria `share-site-creators-share.amp` to `$ALFRESCO_HOME/amps_share`, depois executar `bin/apply_amps.sh`.

Para os desenvolvedores que desejam contribuir, que estão executando localmente, poderá usar o plug-in do Maven para instalar o AMP executando `mvn alfresco:install -Dmaven.alfresco.warLocation=$TOMCAT_HOME/webapps/alfresco` para o repo AMP e `mvn alfresco:install -Dmaven.alfresco.warLocation=$TOMCAT_HOME/webapps/share` para o Share AMP. Se você não estiver executando o seu Alfresco e Share WARs expandido especifique o caminho do arquivo WAR em vez do diretório.

Uma vez que os AMPs estiverem implantados, inicie o Alfresco.

### Implantar o módulo no Share

Depois de iniciar o Alfresco com os AMPs implantados, o módulo Share deve ser implantado automaticamente para você. Se você ainda conseguir ver a opção "Criar Sites" você precisa fazer a implantação dos módulos manualmente. Para fazê-lo, navegue até [Share Module Deployment Console](http://localhost:8080/share/service/modules/deploy) para implantar o módulo. Depois de clicar em "Apply Changes", faça log out, somente então entre novamente. Se você ainda não tiver um grupo criado com seu nome de usuário nele, os links "Criar Site" devem ser eliminados, mesmo se você for um administrador.

### Criar e popular o grupo

O grupo SITE_CREATORS será criado para você automaticamente. Se por alguma razão não for criado, crie um novo grupo com o ID de "GROUP_SITE_CREATORS". Você pode adicionar pessoas e grupos nesse grupo. Por exemplo, provavelmente você vai quere adicionar ALFRESCO_ADMINISTRATORS neste grupo.

Usando um nome de grupo diferente
------------------------
Se você quiser usar um nome de grupo diferente, será necessário alterar em dois lugares. Primeiro, no projeto repo, altere `src/main/amp/config/alfresco/module/share-site-creators-repo/context/service-context.xml`. Faça busca por "GROUP_SITE_CREATORS" e você irá encontrálo.

Segundo, Você pode alterar o grupo quando você implantar o módulo, ou na camada Share do projeto, alterar a declaração do avaliador`src/main/amp/config/alfresco/web-extension/site-data/site-creators-module-extension.xml`.
