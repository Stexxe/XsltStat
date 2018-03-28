<?xml version="1.0" encoding="UTF-8"?>
<!--
	$Log: RabukaPDFXML_validate.xsl,v $
	Revision 1.10  2018/02/12 15:50:26  Phil.Fitzsimons
	ISCINT-25424 - Map V10
	
	Revision 1.9  2018/02/09 15:53:07  Phil.Fitzsimons
	ISCINT-25424 - Map V10
	
	Revision 1.8  2018/02/07 09:26:58  Phil.Fitzsimons
	ISCINT-25424 - Map V10
	
	Revision 1.7  2017/12/18 14:03:38  Phil.Fitzsimons
	ISCINT-24385 - Map V9 some
	
	Revision 1.6  2017/10/24 10:44:07  Phil.Fitzsimons
	ISCINT-20132 - Add Value
	
	Revision 1.5  2017/10/06 14:33:31  Phil.Fitzsimons
	ISCINT-20132 - Add more validation
	
	Revision 1.4  2017/10/03 16:09:31  Phil.Fitzsimons
	ISCINT-20132 - Add validation
	
	Revision 1.3  2017/10/03 16:06:54  Phil.Fitzsimons
	ISCINT-20132 - Add validation
	
	Revision 1.2  2017/10/03 15:29:00  Phil.Fitzsimons
	ISCINT-20132 - Add validation
	
	Revision 1.1  2017/10/02 15:37:47  Phil.Fitzsimons
	ISCINT-20132 - Add validation
	
		
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xdt="http://www.w3.org/2005/04/xpath-datatypes" xmlns:knfunc="de.kn.xslt.extensions.KnFunctions" xmlns:eimf="de.ei.xslt.extensions.MetaFile"
    xmlns:eicf="de.ei.xslt.extensions.ControlFile" xmlns:eicnt="de.ei.xslt.extensions.Counter" xmlns:eienv="de.ei.xslt.extensions.Environment"
    xmlns:plausi="de.ei.xslt.extensions.PlausiChecker" xmlns:dc="de.ei.xslt.extensions.DateConv" xmlns:my="local-functions" xmlns:ext="http://exslt.org/common"
    exclude-result-prefixes="ext" extension-element-prefixes="fn xs xdt knfunc eimf eicf eicnt eienv plausi dc my">



    <xsl:output method="text" encoding="ISO-8859-1" indent="yes"/>

    <xsl:variable name="creationDate" as="xs:string" select="format-date(current-date(), '[Y0001][M01][D01]')"/>
    <xsl:variable name="creationDay" as="xs:string" select="format-date(current-date(), '[D01]')"/>
    <xsl:variable name="creationMonth" as="xs:string" select="format-date(current-date(), '[M01]')"/>
    <xsl:variable name="nl">
        <xsl:text>&#xa;</xsl:text>
    </xsl:variable>

    <xsl:variable name="creationTime" as="xs:string" select="format-time(current-time(), '[H01][m01][s01]')"/>
    <xsl:variable name="creationDateTime" as="xs:string" select="concat($creationDate,$creationTime)"/>
    <xsl:variable name="ENV" select="if(eienv:get-env('INSTANCEMODE') = 'P') then 'PROD' else 'TEST'"/>
    <xsl:variable name="AIX" select="if(eienv:get-env('HOSTNAME') != '') then 'Y' else 'N'"/>

    <xsl:template match="/">
        <xsl:variable name="DocId" select="/Collection/DocumentMetadata/DocumentId"/>
        <xsl:variable name="VATBOX_Msg"
            select="concat('Due to a mistake made by the user, we cannot accept this travel expense. Please ignore travel expense ',$DocId,' date = ',/Collection/DocumentMetadata/Created,' located in documentmetadata-',$DocId,'.xml',$nl)"/>
        <xsl:variable name="errors">

            <xsl:if test="count(/Collection/Invoice) != count(/Collection/DocumentMetadata/PropertyList/Property[Key='AccountingSystemId']/Value[string-length(string(.)) &gt; 0])">
                <xsl:text>ERRORS: Matricule ZADIG absent - verifier la valeur AccountingSystemId !</xsl:text>
            </xsl:if>

            <xsl:variable name="ACC_Property" select="/Collection/CompanyAccountInfo/Properties/Property"/>
            <xsl:variable name="CustomerAssigneId" select="my:conv(1,substring($ACC_Property,string-length($ACC_Property) - 3,4))"/>

            <xsl:if test="$CustomerAssigneId = 'Unknown'">
                <xsl:text>Code Compagnie KUEHNE+NAGEL inconnu - vérifier la valeur CustomerAssignedid !</xsl:text>
            </xsl:if>


            <xsl:for-each select="/Collection/Invoice/InvoiceLine/AccountingCostCode">
                <xsl:variable name="AccountCode" select="substring(.,1,7)"/>
                <xsl:variable name="Deduction" select="my:conv(3,$AccountCode)"/>
                <xsl:message select="concat('Deduction Code : ',$Deduction)"/>
                <xsl:if
                    test="sum(../Price/PriceAmount[@currencyID='EUR']) = 0 or sum(../TaxTotal/TaxSubtotal/TaxAmount[@currencyID='EUR']) = 0 or count(../TaxTotal/TaxSubtotal/TaxAmount[@currencyID='EUR'][. = 0]) &gt; 0">
                    <xsl:value-of select="concat('ERRORS: Note de frais vide - le salarié a remonté une note de frais à zéro euros ! :',$AccountCode,' Deduction ',$Deduction,$nl)"
                    />
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$Deduction='N'">
                        <xsl:if test="count(../Price/PriceAmount[@currencyID='EUR']) = 0">
                            <xsl:value-of
                                select="concat('ERRORS: probleme avec le montant a payer, controler le fichier genere par ABUKAI :',$AccountCode,' Deduction ',$Deduction,$nl)"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$Deduction='D'">
                        <xsl:if test="count(../TaxTotal/TaxSubtotal/LineExtensionAmount[@currencyID='EUR']) = 0">
                            <xsl:value-of
                                select="concat('ERRORS: probleme avec le montant a payer, controler le fichier genere par ABUKAI :',$AccountCode,' Deduction ',$Deduction,$nl)"/>
                        </xsl:if>
                        <xsl:if test="sum(../TaxTotal/TaxAmount[@currencyID='EUR']) &lt; 0">
                            <xsl:value-of
                                select="concat('ERRORS: Erreur dans le fichier généré par ABUKAI - le montant est négatif ! Contacter ABUKAI le fichier est incorrect :',$AccountCode,' Deduction ',$Deduction,$nl)"
                            />
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="concat('ERRORS: probleme avec le montant a payer, controler le fichier genere par ABUKAI : ',$AccountCode,' pas dans la table des codes',$nl)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$errors != ''">
            <xsl:value-of select="$VATBOX_Msg"/>
            <xsl:value-of select="$nl"/>
            <xsl:value-of select="$errors"/>
            <xsl:variable name="QNum" select="if($AIX = 'Y') then eicf:get-common-block('QNO') else '666'"/>
            <xsl:value-of select="concat('IBroker Queue : Q',$QNum,' - Date : ',$creationDate,' - Time : ',$creationTime,$nl)"/>
            <xsl:variable name="ACC_Property" select="/Collection/CompanyAccountInfo/Properties/Property"/>
            <xsl:variable name="payr_nm" select="my:conv(1,substring($ACC_Property,string-length($ACC_Property) - 3,4))"/>
            <xsl:if test="$payr_nm != 'Unknown'">
                <xsl:value-of select="concat('PAC=',my:conv(2,$payr_nm),$nl)"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:function name="my:conv">
        <xsl:param name="TableNumber"/>
        <xsl:param name="Key"/>
        <xsl:variable name="URI" select="'../tabs/RabukaPDFXML.xml'"/>
        <xsl:choose>
            <xsl:when test="document($URI)/Tables/Table[@TableNumber=$TableNumber]/Value[@Key=$Key]">
                <xsl:value-of select="document($URI)/Tables/Table[@TableNumber=$TableNumber]/Value[@Key=$Key]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="document($URI)/Tables/Table[@TableNumber=$TableNumber]/Default">
                        <xsl:value-of select="document($URI)/Tables/Table[@TableNumber=$TableNumber]/Default"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            <xsl:value-of select="concat('TABLENUMBER ',$TableNumber,' TABLEERROR: ', document($URI)/Tables/Table[@TableNumber=$TableNumber]/Error,$Key)"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
