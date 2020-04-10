<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:param name="treed"/>
    <xsl:variable name="treed-chemical" select="doc($treed)"/>
    
    <xd:doc>
        <xd:desc>Template qui enrichit day14-flat.xml avec la profondeur maximum dans l'arborescence de day14-treed.xml
        Ceci permet d'indiquer pour chaque composant quelle est la première étape où il peut être remplacé par ses réactifs, 
        car il peut ne plus servir de réactif lui-même</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <chemicals>
            <xsl:for-each select="/chemicals/chemical">
                <xsl:sort select="max($treed-chemical//chemical[@input=current()/@output]/count(ancestor-or-self::chemical))"/>
                <xsl:variable name="name" select="@output"/>
                <xsl:copy>
                    <xsl:attribute name="name" select="$name"/>
                    <xsl:attribute name="depth" select="max($treed-chemical//chemical[@input=$name]/count(ancestor-or-self::chemical))"/>
                </xsl:copy>
            </xsl:for-each>
        </chemicals>
    </xsl:template>

</xsl:stylesheet>