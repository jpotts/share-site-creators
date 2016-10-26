share-site-creators
==============

This add-on gives you the ability to restrict Alfresco Share site creation to a specific group of users. Users not in the group will not see a "Create Site" link in:

* The header Sites dropdown menu
* The My Sites dashlet
* The "welcome" dashlet

In addition, for users not in the group, the "welcome" dashlet's text changes to explain what a Share site is but does not imply that they have the ability to create one. A nice enhancement might be a link that launches a workflow to request a new site. (Pull requests welcome!)

By default, the group the module looks for must have an ID of "GROUP_SITE_CREATORS". The display name can be anything. When you create the group you do not specify "GROUP_"--Alfresco will prepend that for you.

This add-on also changes the low-level permissions so that even if someone figures out how to create a site without the user interface, the repository tier won't let them do that unless they are in the group.

Maven
-----
Add the dependencies and overlays to the POM files of your WAR projects.

For the repository tier, in a project created with the all-in-one archetype, edit repo/pom.xml:


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

For the Share tier, in a project created with the all-in-one archetype, edit share/pom.xml:

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

Manual Installation
-------------------
There are two AMPs associated with this add-on. One is a "repo tier" AMP and the other is a "Share tier" AMP.

For each of the two projects, use `mvn install` to create the AMP. When running with 5.1.f, you must specify `-Ddependency.surf.version=6.3` when running maven commands for the Share tier AMP.

### Install the AMPs

You can install the AMPs as you normally would using the MMT. For example, to install on a server, you would copy `share-site-creators-repo.amp` to `$ALFRESCO_HOME/amps` and copy `share-site-creators-share.amp` to `$ALFRESCO_HOME/amps_share`, then run `bin/apply_amps.sh`.

For developers looking to contribute who are running locally, you can use the Maven plug-in to install the AMP by running `mvn alfresco:install -Dmaven.alfresco.warLocation=$TOMCAT_HOME/webapps/alfresco` for the repo AMP and `mvn alfresco:install -Dmaven.alfresco.warLocation=$TOMCAT_HOME/webapps/share` for the Share AMP. If you are not running your Alfresco and Share WARs expanded specify the WAR file path instead of the directory.

Once the AMPs are deployed, start up Alfresco.

### Deploy the Module in Share

After starting Alfresco with the AMPs deployed, the Share module should be deployed for you automatically. If you can still see "Create Sites" you may need to deploy the module manually. To do so, go to the [Share Module Deployment Console](http://localhost:8080/share/service/modules/deploy) to deploy the module. After you hit "Apply Changes", log out, then log back in. If you don't already have a group created with your username in it, the "Create Site" links should be gone, even if you are an administrator.

### Create and Populate the Group

The SITE_CREATORS group will be created for you automatically. If, for some reason, it does not get created, create a new group with an ID of "GROUP_SITE_CREATORS". You can add individuals and groups to this group. For example, at the very least you will probably want to add ALFRESCO_ADMINISTRATORS to this group.

Using a Different Group Name
------------------------
If you want to use a different group it needs to be changed in two places. First, in the repo project, change `src/main/amp/config/alfresco/module/share-site-creators-repo/context/service-context.xml`. Do a search for "GROUP_SITE_CREATORS" and you'll find it.

Second, you can either change the group when you deploy the module, or in the Share tier project, change the evaluator declaration in `src/main/amp/config/alfresco/web-extension/site-data/site-creators-module-extension.xml`.
