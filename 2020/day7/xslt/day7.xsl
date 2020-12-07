<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    
    <xsl:template match="/">
        <Bags>
            <xsl:apply-templates select="//Bag/Bag[@color='shiny gold']">
                <xsl:with-param name="multiplier" select="1"/>
            </xsl:apply-templates>
        </Bags>
    </xsl:template>
    
    <xsl:template match="Bag">
        <xsl:param name="multiplier"/>
        <Bag>
            <xsl:attribute name="quantity" select="@quantity * $multiplier"/>
            <xsl:attribute name="color" select="parent::Bag/@color"/>
            <xsl:apply-templates select="//Bag/Bag[@color = current()/parent::Bag/@color]">
                <xsl:with-param name="multiplier" select="@quantity * $multiplier"/>
            </xsl:apply-templates>
        </Bag>
    </xsl:template>
</xsl:stylesheet>