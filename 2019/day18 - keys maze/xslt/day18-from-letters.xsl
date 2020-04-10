<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <distances>
            <!-- on calcule tous les trajets possibles au départ du point de départ ou des clefs -->
            <xsl:for-each select="/distances/cell[@text='@' or upper-case(@text)!=@text]">
                <xsl:apply-templates select=".">
                    <xsl:with-param name="letters" as="node()">
                        <letters/>
                    </xsl:with-param>
                    <xsl:with-param name="distance" select="0"/>
                </xsl:apply-templates>
            </xsl:for-each>
        </distances>
    </xsl:template>

    <xsl:template match="distances/cell">
        <xsl:param name="letters" as="node()"/>
        <xsl:param name="distance"/>
        
        <xsl:variable name="line" select="@line"/>
        <xsl:variable name="column" select="@column"/>
        
        <!-- On s'interdit de boucler -->
        <xsl:if test="not($letters//cell[@line=$line and @column=$column])">
            <cell>
                <xsl:copy-of select="@*"/>
                <xsl:attribute name="distance" select="$distance"/>
                <!-- On ne repasse pas par l'origine, afin de diviser par environ 4 le nombre de trajets possibles, sans perdre les distances optimales -->
                <xsl:for-each select="cell[not(@text='@')]">
                    <xsl:apply-templates select="//distances/cell[@line=current()/@line and @column=current()/@column]">
                        <xsl:with-param name="letters">
                            <letters>
                                <xsl:copy-of select="$letters//cell"/>
                                <cell line="{$line}" column="{$column}"/>
                            </letters>
                        </xsl:with-param>
                        <xsl:with-param name="distance" select="@distance"/>
                    </xsl:apply-templates>
                </xsl:for-each>
            </cell>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>