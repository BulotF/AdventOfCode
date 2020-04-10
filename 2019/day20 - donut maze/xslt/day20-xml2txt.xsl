<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- Il faut bien préciser que l'on souhaite avoir du texte et non du xml pour éviter d'avoir les en-tête en début de fichier -->
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//line"/>
    </xsl:template>

    <xsl:template match="line">
        <!-- Le séparateur par défaut est l'espace ; il faut donc préciser que l'on souhaite ne pas en avoir -->
        <xsl:value-of select="cell" separator=""/>
        <!-- Le passage à la ligne -->
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>

</xsl:stylesheet>