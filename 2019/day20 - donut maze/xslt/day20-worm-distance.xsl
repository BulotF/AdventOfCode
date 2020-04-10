<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <!-- on calcule les distances au départ de AA ou d'une intersection -->
    <xsl:template match="/">
        <distances>
            <xsl:apply-templates select="//distances/cell[@text='.' or @text='AA']" mode="beginning"/>
        </distances>
    </xsl:template>

    <xsl:template match="cell" mode="beginning">
        <cell>
            <xsl:copy-of select="@line"/>
            <xsl:copy-of select="@column"/>
            <xsl:copy-of select="@text"/>
            <xsl:for-each select="cell">
                <xsl:choose>
                    <!-- on ne va pas plus loin si on est tout de suite sur ZZ ou une intersection -->
                    <xsl:when test="@text='ZZ' or @text='.'">
                        <cell line="{@line}" column="{@column}" text="{@text}" distance="{@distance}" floor="{number(@out) - number(../@in)}"/>
                    </xsl:when>
                    <!-- sinon, on va chercher les trajets au départ du noeud courant pour passer au travers des trous de ver -->
                    <!-- en listant les points de passage pour éviter les boucles -->
                    <xsl:otherwise>
                        <xsl:apply-templates select="//distances/cell[@text = current()/@text]" mode="worm">
                            <xsl:with-param name="distance" select="@distance" as="xs:double"/>
                            <xsl:with-param name="floor" select="number(@out) - number(../@in)" as="xs:double"/>
                            <xsl:with-param name="steps" as="node()">
                                <steps>
                                    <step><xsl:value-of select="@text"/></step>
                                </steps>
                            </xsl:with-param>
                            <xsl:with-param name="init-line" select="../@line" tunnel="yes"/>
                            <xsl:with-param name="init-column" select="../@column" tunnel="yes"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </cell>
    </xsl:template>

    <xsl:template match="cell" mode="worm">
        <xsl:param name="distance" as="xs:double"/>
        <xsl:param name="floor" as="xs:double"/>
        <xsl:param name="steps" as="node()"/>
        <xsl:param name="init-line" tunnel="yes"/>
        <xsl:param name="init-column" tunnel="yes"/>

        <xsl:for-each select="cell">
            <!-- on affiche la position, la distance et l'évolution du nombre d'étages si on est sur ZZ ou sur une intersection -->
            <xsl:choose>
                <xsl:when test="@text='ZZ' or @text='.'">
                    <xsl:if test="@line != $init-line or @column != $init-column or ($floor + number(@out) - number(../@in)) != 0">
                        <cell line="{@line}" column="{@column}" text="{@text}" distance="{$distance + @distance}" floor="{$floor + number(@out) - number(../@in)}"/>
                    </xsl:if>
                </xsl:when>
                <!-- on continue à parcourir les trous de ver sinon en évitant de repasser par des trous de ver déjà parcourus -->
                <xsl:otherwise>
                    <xsl:if test="not($steps//step/text() = @text)">
                        <xsl:apply-templates select="//distances/cell[@text = current()/@text]" mode="worm">
                            <xsl:with-param name="distance" select="$distance + number(@distance)" as="xs:double"/>
                            <xsl:with-param name="floor" select="$floor + number(@out) - number(../@in)" as="xs:double"/>
                            <xsl:with-param name="steps" as="node()">
                                <steps>
                                    <xsl:copy-of select="$steps//step"/>
                                    <step><xsl:value-of select="@text"/></step>
                                </steps>
                            </xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>