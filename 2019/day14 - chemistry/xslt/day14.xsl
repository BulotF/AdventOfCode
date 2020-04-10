<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <!-- A la racine était le FUEL... -->
        <chemical output="FUEL">
            <!-- Puis il appela sa propre formule chimique -->
            <xsl:apply-templates select="//chemical[@output='FUEL']"/>
        </chemical>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            Template récursif qui écrit la quantité du composant produit
            Puis pour réactif :
            - écrit son nom et la quantité nécessaire
            - appelle le template qui permet de le produire
        </xd:desc>
    </xd:doc>
    <xsl:template match="chemical">
        <xsl:attribute name="outquantity" select="@outquantity"/>
        <xsl:for-each select="chemical">
            <xsl:variable name="name" select="@input"/>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates select="//chemical[@output=$name]"/>
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>