<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

    <xsl:param name="text-file" select="'day14.txt'"/>
    <xsl:variable name="text-content" select="unparsed-text($text-file)"/>

    <xsl:template match="/">
        
        <chemicals>
            <!-- pour chacun des éléments séparés par des passages à la ligne -->
            <xsl:for-each select="tokenize($text-content,'\n')">
                <!-- output est la partie après => sans espaces avant et après ; le caractère > est écrit &gt; greater than, car c'est un caractère réservé de XML avec < &lt; et & &amp; pour les principaux -->
                <xsl:variable name="output" select="normalize-space(substring-after(.,'=&gt;'))"/>
                <!-- inputs est la partie avant => -->
                <xsl:variable name="inputs" select="substring-before(.,'=&gt;')"/>
                <chemical output="{substring-after($output,' ')}" outquantity="{substring-before($output,' ')}">
                    <!-- pour chaque élément séparé par la virgule -->
                    <xsl:for-each select="tokenize($inputs,',')">
                        <chemical input="{substring-after(normalize-space(.),' ')}" inquantity="{substring-before(normalize-space(.),' ')}"/>        
                    </xsl:for-each>
                </chemical>
            </xsl:for-each>
        </chemicals>
    </xsl:template>

</xsl:stylesheet>