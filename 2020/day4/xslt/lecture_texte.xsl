<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

    <xsl:param name="text-file"/>

    <xsl:template match="/">
        <!-- On crée une variable qui prend en entrée l'adresse du fichier et en contient le contenu textuel -->
        <xsl:variable name="text-content" select="unparsed-text($text-file)"/>
        <idCards>
            <!-- On découpage la chaîne textuelle selon le caractère de passage à la ligne -->
            <xsl:for-each select="tokenize($text-content,'&#xD;')">
                <Card>

                        <xsl:for-each select="tokenize(.,' ')">
                            <xsl:choose>
                                <xsl:when test="not(contains(.,':'))">
                                    <xsl:value-of select="'error'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="{substring-before(.,':')}">
                                        <xsl:value-of select="substring-after(.,':')"/>
                                    </xsl:element>                                    
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    
<!--                    
                    <xsl:attribute name="dot" select="substring-before(.,')')"/>
                    <xsl:choose>
                        <!-\- Cas particulier du caractère de fin de fichier -\->
                        <xsl:when test="contains(.,'&#xD;')">
                            <xsl:attribute name="planet" select="substring-before(substring-after(.,')'),'&#xD;')"/>        
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="planet" select="substring-after(.,')')"/>
                        </xsl:otherwise>
                    </xsl:choose>
-->                    
                </Card>
            </xsl:for-each>
        </idCards>
    </xsl:template>

</xsl:stylesheet>